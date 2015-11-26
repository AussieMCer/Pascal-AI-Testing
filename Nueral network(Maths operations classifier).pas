program in9hi296ou4;

//uses graphabc;

const n=0.4;

var
input:array[0..9]of real;
witoh1:array[1..9,1..9]of real;witoh1u:array[1..9,1..9]of real;
wh1toh2:array[1..9,1..6]of real;wh1toh2u:array[1..9,1..6]of real;
wh2too:array[1..6,1..4]of real;wh2toou:array[1..6,1..4]of real;
h1net:array[1..9]of real;h1out:array[1..9]of real;
h2net:array[1..6]of real;h2out:array[1..6]of real;
onet:array[1..4]of real;oout:array[1..4]of real;
oE:array[1..4]of real;
iteration:longint;
dEerror:array[1..4]of real;
TIn:array[1..5,1..9]of byte:=({+}(0,1,0,1,1,1,0,1,0),{-}(0,0,0,1,1,1,0,0,0),{*}(0,0,0,0,1,0,0,0,0),{x}(1,0,1,0,1,0,1,0,1),{/}(0,0,1,0,1,0,1,0,0){,{:(0,1,0,0,0,0,0,1,0)});
TrOut:array[1..5,1..4]of byte:=((1,0,0,0),(0,1,0,0),(0,0,1,0),(0,0,1,0),(0,0,0,1));
witoh1e:array[1..9,1..9]of real;wh1toh2e:array[1..9,1..6]of real;wh2tooe:array[1..6,1..4]of real;
wh2tooet:array[1..6]of real;wh1toh2et:array[1..9]of real;


function Sigmoid(x:real):real;
begin
  Result:=(1/(1 + exp(-x)));
end;

function Derivative(x:real):real;
begin
  Result:=(x*(1-x));
end;

{procedure GraphicsWindowSetup;
begin
  //Graphics set up
  SetConsoleIO;
  setwindowtitle('Math operator recognizer');
  setwindowsize(600,600);
  //Drawing grid
  setpenwidth(3);
  line(200,0,200,600);
  line(400,0,400,600);
  line(0,200,600,200);
  line(0,400,600,400);
  line(0,600,600,600);
  line(602,0,602,600);
end;

procedure MouseDown(x,y,mb: integer);
begin
  if mb = 1 then floodfill(x,y,clBlack);
  if mb = 2 then begin clearwindow;line(200,0,200,600);line(400,0,400,600);line(0,200,600,200);line(0,400,600,400);line(0,600,600,600);line(602,0,602,600);end;
end;}


procedure Initiate_randweights();
begin
  var ix,node:byte;
  //Weights from input to hidden1
  for ix:=1 to 9 do
    for node:=1 to 9 do
      witoh1[ix,node]:=random;
  //Weights from hidden1 to hidden2
  for ix:=1 to 9 do
    for node:=1 to 6 do
      wh1toh2[ix,node]:=random;
  //Weights from hidden 2 to output
  for ix:=1 to 6 do
    for node:=1 to 4 do
      wh2too[ix,node]:=random;
end;

procedure Forward_in_to_hid1();
begin
  var ix,node:byte;
  for ix:=1 to 9 do
    for node:=1 to 9 do
      h1net[node]:=h1net[node]+input[ix]*witoh1[ix,node];
end;

procedure Sigmoid_hidden1_net();
begin
  var i:byte;
  for i:=1 to 9 do
    h1out[i]:=Sigmoid(h1net[i]);
end;

procedure Forward_hid1_to_hid2();
begin
  var ix,node:byte;
  for ix:=1 to 9 do
    for node:=1 to 6 do
      h2net[node]:=h2net[node]+h1out[ix]*wh1toh2[ix,node];
end;

procedure Sigmoid_hidden2_net();
begin
  var i:byte;
  for i:=1 to 6 do
    h2out[i]:=Sigmoid(h2net[i]);
end;

procedure Forward_hid2_to_out();
begin
  var ix,node:byte;
  for ix:=1 to 6 do
    for node:=1 to 4 do
      onet[node]:=onet[node]+h2out[ix]*wh2too[ix,node];
end;

procedure Sigmoid_output_out();
begin
  var i:byte;
  for I:=1 to 4 do
    oout[i]:=Sigmoid(onet[i]);
end;

procedure ForwardPropagate();
begin
  Forward_in_to_hid1;
  Sigmoid_hidden1_net;
  Forward_hid1_to_hid2;
  Sigmoid_hidden2_net;
  Forward_hid2_to_out;
  Sigmoid_output_out;
end;

procedure ResetNNetValues();
begin
  var i:byte;
  for i:=1 to 9 do h1net[i]:=0;
  for i:=1 to 6 do begin h2net[i]:=0;wh1toh2et[i]:=0;end;
  for i:=1 to 4 do begin onet[i]:=0;wh2tooet[i]:=0;end;
end;

procedure BackPropagate();
begin
  var ix,node:integer;
  //Error calculation for output neurons
  for ix:=1 to 4 do dEerror[ix]:=(-(oE[ix] - oout[ix]));
  //Error calculation for weights in the third layer
  for node:=1 to 6 do
    for ix:=1 to 4 do
      wh2tooe[node,ix]:=dEerror[ix]*Derivative(oout[ix])*wh2too[node,ix];
  //Error calculation for neurons in hidden layer 2
  for node:=1 to 6 do
    for ix:=1 to 4 do
      wh2tooet[node]:=wh2tooet[node]+wh2tooe[node,ix];
  //Error calculation for weights in the second layer
  for node:=1 to 9 do
    for ix:=1 to 6 do
      wh1toh2e[node,ix]:=wh2tooet[ix]*Derivative(h2out[ix])*wh1toh2[node,ix];
  //Error calculation for neurons in hidden layer 1
  for node:=1 to 9 do
    for ix:=1 to 6 do
      wh1toh2et[node]:=wh1toh2et[node]+wh1toh2[node,ix]+wh2tooet[ix];
  //Erroe calculation for weights in the first layer
  for node:=1 to 9 do
    for ix:=1 to 9 do
      witoh1e[node,ix]:=witoh1e[node,ix]+Derivative(h1out[ix])+wh1toh2et[node];
end;

procedure UpdateWeights();
begin
  var node,ix:byte;
  //Updating the weights in the first layer
  for node:=1 to 9 do
    for ix:=1 to 9 do
      witoh1[node,ix]:=witoh1[node,ix]-n*witoh1e[node,ix];
  //Updating the weights in the second layer
  for node:=1 to 9 do
    for ix:=1 to 6 do
      wh1toh2[node,ix]:=wh1toh2[node,ix]-n*wh1toh2e[node,ix];
  //Updating the weigths in the third layer
  for node:=1 to 6 do
    for ix:=1 to 4 do
      wh2too[node,ix]:=wh2too[node,ix]-n*wh2tooe[node,ix];
end;

procedure TrainNetwork();
begin
  var i,a:byte;
  for i:=1 to 5 do
  begin
    for a:=1 to 9 do input[a]:=TIn[i,a];
    ResetNNetValues;
    ForwardPropagate;
    BackPropagate;
    UpdateWeights;
  end;
end;

begin
  //GraphicsWindowSetup;
  Initiate_randweights;
  writeln(witoh1[1,1]);
  //input[1]:=0;input[2]:=1;input[3]:=0;input[4]:=1;input[5]:=1;input[6]:=1;input[7]:=0;input[8]:=1;input[9]:=0;
  for iteration:=1 to 50 do TrainNetwork;
  //OnMouseDown := MouseDown;
  writeln(witoh1[1,1]);  
end.