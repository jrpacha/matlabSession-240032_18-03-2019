clearvars
close all

a=0.0;
b=2.0;
L=b-a;

a1=1.3;
a0=-0.9;
ff=0.0;

u0=1.3;
duL=2.0;

numElem=4;

%solExacta:
omega=sqrt(-a0/a1);
A=u0;
B=(duL+A*omega*sin(omega*b))/(omega*cos(omega*b));
f=@(x) A*cos(omega*x)+B*sin(omega*x);

%Geometry
h=L/numElem;
nodes=(a:0.5*h:b)';
numNod=size(nodes,1);    
elem=zeros(numElem,3); %Connectivity matrix
for e=1:numElem
    k=2*e-1;
    elem(e,:)=[k,k+1,k+2];
end
%Assembly of the global system
K=zeros(numNod);
F=zeros(numNod,1);
Q=zeros(numNod,1); 
u=zeros(numNod,1);
Ke=a1/(3*h)*[7,-8,1;-8,16,-8;1,-8,7]+ ...
        a0*h/30*[4,2,-1;2,16,2;-1,2,4];
Fe=ff*h/6.0*[1;4;1];
for e=1:numElem   
    rows=[elem(e,1);elem(e,2);elem(e,3)];
    cols=rows;  
    K(rows,cols)=K(rows,cols)+Ke;
    F(rows,1)=F(rows,1)+Fe;
end
fixedNod=1;%[1,numNod];
freeNod=setdiff(1:numNod,fixedNod);

%Natural B.C.:
Q(numNod)=a1*duL;

%Essential B.C.
u(fixedNod)=u0;

%Reduced system
Qm=Q(freeNod)+F(freeNod)-K(freeNod,fixedNod)*u(fixedNod);
%Fm=F(freeNod)+Qm;
Km=K(freeNod,freeNod);
um=Km\Qm;
u(freeNod)=um;
    
%Post process
Q=K*u-F;

%Mean value (of the approximated FEM solution).
U=sum(u)/numNod;    
fprintf('Sol. Mean val.of the approx.solution,\n')
fprintf('<u> = %12.6e\n',U)
[nodes,u,f(nodes)]
