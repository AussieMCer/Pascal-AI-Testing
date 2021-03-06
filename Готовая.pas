uses graphabc;

const n=0.01;

var
  input:array[1..784]of real;output:array[0..9]of real;inputscan:array[1..28,1..28]of real;
  finput:array[1..49999,1..784]of real;finputn:array[1..49999]of byte;
  witoh1:array[1..784, 1..100]of real;wh1too:array[1..100, 0..9]of real;
  h1net, h1out:array[1..100]of real;onet, oout:array[0..9]of real;
  wh1tooe:array[1..100, 0..9]of real;witoh1e:array[1..784,1..100]of real;
  nh1e:array[1..100]of real;dEerror:array[0..9]of real;
  a,b,d: integer;
  infl:text;

procedure lines;
begin
  setwindowsize(280,280);
  clearwindow(clblack);
  setpencolor(clwhite);
  var a:integer;
  for a:=1 to 28 do line(10*a,0,10*a,280);
  for a:=1 to 28 do line(0,10*a,280,10*a);
end;

procedure MouseDown(x,y,mb: integer);
begin
  MoveTo(x,y);
  if mb= 2 then lines;
end;

procedure MouseMove(x,y,mb: integer);
begin
  if mb=1 then floodfill(x,y,clwhite);
end;

function Sigmoid(x: real): real;
begin
  Result:=1/(1+exp(-x));
end;

function Derivative(x: real): real;
begin
  Result:=x*(1-x);
end;

procedure RandomWeights;
begin
  //randomize(0);
  var node,w:integer;
  for node:=1 to 784 do
    for w:=1 to 100 do
      witoh1[node,w]:=random(-1,1);
  for node:=1 to 100 do
    for w:=0 to 9 do
      wh1too[node,w]:=random(-1,1);
end;

procedure ForwardPropagate;
begin
  var node,w:integer;
  for node:=1 to 784 do
    for w:=1 to 100 do
      h1net[w]:=h1net[w]+input[w]*witoh1[node,w];
  for node:=1 to 100 do h1out[node]:=Sigmoid(h1net[node]/100000);
  for node:=1 to 100 do
    for w:=0 to 9 do
      onet[w]:=onet[w]+h1out[node]*wh1too[node,w];
  for node:=0 to 9 do oout[node]:=Sigmoid(onet[node]/1000);
end;

procedure BackPropagate;
begin
  var node, w: integer;
  for node:=0 to 9 do dEerror[node]:=sqr(output[node]-oout[node])/2;
  for node:=1 to 100 do
    for w:=0 to 9 do
      wh1tooe[node, w]:=dEerror[w]*Derivative(oout[w]*0.00001)*wh1too[node,w];  
  for node:=1 to 100 do
    for w:=0 to 9 do
      nh1e[node]:=nh1e[node]+wh1tooe[node,w]; 
  for node:=1 to 784 do
    for w:=1 to 100 do
      witoh1e[node,w]:=nh1e[w]*Derivative(h1out[w]*0.001)*witoh1[node,w];
end;

procedure UpdateWeights;
begin
  var node,w:integer;
  for node:=1 to 100 do
    for w:= 1 to 784 do
      witoh1[w,node]:=witoh1[w,node]-n*witoh1e[w,node];
  for node:=0 to 9 do
    for w:=1 to 100 do
      wh1too[w,node]:=wh1too[w,node]-n*wh1too[w,node];
end;

procedure ResetValues;
begin
  var a:integer;
  for a:=1 to 100 do begin h1net[a]:=0;nh1e[a]:=0;end;
  for a:=0 to 9 do onet[a]:=0;
end;

procedure Scan;
begin
  var a,b,i,k,j:integer;
  var c:real;
  for a:=1 to 28 do
    for b:=1 to 28 do
      inputscan[a,b]:=0;
  for a:=1 to 784 do input[a]:=0;
  for a:=1 to 28 do
    for b:=1 to 28 do
      if getpixel(b*10-1,a*10-1)=rgb(255,255,255)then inputscan[a,b]:=0.99 else inputscan[a,b]:=0;
  k:=1;
  for i:=1 to 28 do
    for j:=1 to 28 do
    begin
      input[k]:=inputscan[i,j];
      inc(k);
    end;
  ResetValues;
  ForwardPropagate;
  c:=oout[0];
  d:=0;
  for a:=1 to 9 do if oout[a]>c then begin c:=oout[a];d:=a;end;
  writeln('�������������� �����:',d);
end;

procedure keyPressed(Key: integer);
begin
  case Key of
   VK_return:Scan;
  end;
end;

procedure KeyPress(Ch: char);
begin
end;

procedure Train;
begin
  ResetValues;
  ForwardPropagate;
  BackPropagate;
  UpdateWeights;
end;
  
begin
  assign(infl,'C:\Users\AO\Desktop\output(50000).txt');reset(infl);
  lines;
  SetConsoleIO;
  OnMouseDown := MouseDown;
  OnMouseMove := MouseMove;
  OnKeyDown:=keyPressed;
  OnKeyPress:=KeyPress;
  for a:=1 to 1000 do
    begin
      for b:=1 to 784 do read(infl,finput[a,b]);
      readln(infl,finputn[a]);
    end;
  RandomWeights;
  for a:=1 to 1000 do 
  begin
    for b:=1 to 784 do input[b]:=finput[a,b];
    for b:=0 to 9 do output[b]:=0;
    output[finputn[a]]:=0.99;
    Train;
  end;
  writeln('����� ����������:',milliseconds/1000,' ������');
end.