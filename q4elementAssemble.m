function Kadd=q4elementAssemble(Keg,NE,DEG,NN,Element)

% PlaneTrussAssemble    Assemble the Element Stiffness/Mass Matrix of a 2D Frame
%                       member to Global Stiffness/Mass Matrix
%                  Kadd    Global Stiffness additive/Mass Matrix
%                  Keg    GlobalElement Stiffness/Mass Matrix
%                 X    Row Matrix for DOF of each element
%                  

X=zeros(1,DEG*4);
Kadd=zeros(DEG*NN,DEG*NN);

for l=1:1:NE
    
 for j= DEG-1:-1:0
    X(DEG-j)=DEG*Element(l,2)-j;
    X(2*DEG-j)=DEG*Element(l,3)-j;
    X(3*DEG-j)=DEG*Element(l,4)-j;
    X(4*DEG-j)=DEG*Element(l,5)-j;
    
 end
 
 for m=1:1:4*DEG
    for n=1:1:4*DEG
        p=X(1,m);
        q=X(1,n);
        Kadd(p,q)=Kadd(p,q)+Keg(m,n,l);
    end
 end
 
end
    
    
