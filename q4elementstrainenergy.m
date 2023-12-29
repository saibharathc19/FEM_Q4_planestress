function [SE,SE_structure,SE_global] =q4elementstrainenergy(Element,Node,DEG,NE,NN,Displacement,Kel,GStiffness)

X=zeros(4*DEG,2);
NIP=1;
XNI=zeros(NIP,2);
sigma=zeros(3,NE);
SE=zeros(NE,1);
for l=1:NE
X(1,1)=(Element(l,2)*2)-1;
X(2,1)=(Element(l,2)*2);
X(3,1)=(Element(l,3)*2)-1;
X(4,1)=(Element(l,3)*2);
X(5,1)=(Element(l,4)*2)-1;
X(6,1)=(Element(l,4)*2);
X(7,1)=(Element(l,5)*2)-1;
X(8,1)=(Element(l,5)*2);

for i=1:1:4*DEG
    for j=1:1:NN*DEG
        if(Displacement(j,1)==X(i,1))
            X(i,2)=Displacement(j,2);

        end
    end
end


SE(l,1)=(X(:,2).')*Kel(:,:,l)*X(:,2);
     
end
SE_structure=sum(SE);  
SE_global=(Displacement(:,2).')*GStiffness*(Displacement(:,2));

        
        
        

        
        
