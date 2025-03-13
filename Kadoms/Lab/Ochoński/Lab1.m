% this script determines a Homogeneous Transformation matrix
clear 
% declaration of symbols
syms d1 a1 th2 a2 th3 th4 d4 q2 q3 q4
% determination of a symbolic form of HT matrices –
% application of mA function
A1=mA(0,d1,a1,0)
A2=mA(th2,0,a2,0)
A3=mA(th3,0,0,sym(-pi/2))
A4=mA(th4,d4,0,0)
% multiplication of matrices
T04=A1*A2*A3*A4
% substitution of rotational joint variables
% for the simplification purpose
T04v=subs(T04,{th2,th3,th4},{q2,q3,q4});
% indication of joint coordinates
% variables: th1,th2 and a3 indicated by ‘1’s
zmie=[[0,1,0,0];[1,0,0,0];[1,0,0,0];[1,0,0,0]]
% a simplified form of the evaluated HT matrices
% for interpretation purpose for a user
T04u=zam(zmie,T04v,"q")

% example of substitution of the join variables values
% and constant values into the T0e matrix for the RRP manipulator example
% please use meters and radians
%T04n=subs(T04,{d1,th2,th3,th4},{0.2,pi/2,-pi/2,0})
%% 

clear 
% declaration of symbols
syms d1 a1 th2 a2 th3 th4 d4 q2 q3 q4
% determination of a symbolic form of HT matrices –
% application of mA function
A1=mA(0,d1,a1,0)
A2=mA(th2,0,a2,0)
A3=mA(th3,0,0,sym(-pi/2))

% multiplication of matrices
T03=A1*A2*A3
% substitution of rotational joint variables
% for the simplification purpose
T03v=subs(T03,{th2,th3},{q2,q3});
% indication of joint coordinates
% variables: th1,th2 and a3 indicated by ‘1’s
zmie=[[0,1,0,0];[1,0,0,0];[1,0,0,0];[1,0,0,0]]
% a simplified form of the evaluated HT matrices
% for interpretation purpose for a user
T03u=zam(zmie,T03v,"q")


syms d41

T03u*[0;0;d41;1]

A1=mA(th4,d4,0,0)
T3e=subs(A1,{th4},{q4})
zmie=[1,0,0,0]
T3u=zam(zmie,T3e,'q')
