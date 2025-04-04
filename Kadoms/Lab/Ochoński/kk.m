addpath Biblioteka

%% 3D visualisation
clear 
close all 

% declaration of symbols
syms d1 a1 th2 a2 th3 alpha3 d4 th5 d5 q2 q3 q5
%put values of angles Ti in degrees and values of arms Di&Aai in meters

%%
arm_A1 = 0.2; %m
joint_D1 = [-0.1, 0, 0.05 0.1]; %m
%joint_D1 = [0.1, 0.1, 0.1, 0.1]; %m

arm_A2 = 0.2; %m
jointTh2 = [-80, -30, 45, 88]; %deg +-90deg
%jointTh2 = [0,0,0,0]; %deg +-90deg

Tr2 = deg2rad(jointTh2);

jointTh3 = [-170, -10, -45, -60]; %deg -180deg <-> 0 deg
%jointTh3 = [0,0,0,0]; %deg -180deg <-> 0 deg
Tr3 = deg2rad(jointTh3);
Alpha3 = -pi/2; %rad 

arm_D4 = 0.1; %m

jointTh5 = [10,150,270,340]; %deg 0deg <-> 360 deg
%jointTh4 = [0,0,0,0]; %deg 0deg <-> 360 deg
Tr5 = deg2rad(jointTh5);
arm_D5 = 0.3; %m

number_of_possitions = 4;
% determination of a symbolic form of HT matrices –
% application of mA function
A1=mA(0,d1,a1,0);
A2=mA(th2,0,a2,0);
A3=mA(th3,0,0,sym(-pi/2));
A4=mA(0,d4,0,0);
A5=mA(th5,d5,0,0);
%% multiplication of matrices
T05=A1*A2*A3*A4*A5;
T04=A1*A2*A3*A4;
T03=A1*A2*A3;
T02=A1*A2;
T01=A1;
% substitution of rotational joint variables
% for the simplification purpose
T5eS=subs(T05,{th2,th3,th5},{q2,q3,q5});
T4eS=subs(T04,{th2,th3},{q2,q3});
T3eS=subs(T03,{th2,th3},{q2,q3});
T2eS=subs(T02,{th2},q2);
T1eS=subs(T01);

T5eV = zeros(4,4,number_of_possitions);
T4eV = zeros(4,4,number_of_possitions);
T3eV = zeros(4,4,number_of_possitions);
T2eV = zeros(4,4,number_of_possitions);
T1eV = zeros(4,4,number_of_possitions);
for k=1:number_of_possitions
    T5eV(:,:,k)=subs(T05,{d1,a1,th2,a2,th3,alpha3,d4,th5,d5},{joint_D1(k),arm_A1,Tr2(k),arm_A2,Tr3(k),Alpha3,arm_D4,Tr5(k),arm_D5});
    T4eV(:,:,k)=subs(T04,{d1,a1,th2,a2,th3,alpha3,d4},{joint_D1(k),arm_A1,Tr2(k),arm_A2,Tr3(k),Alpha3,arm_D4});
    T3eV(:,:,k)=subs(T03,{d1,a1,th2,a2,th3,alpha3},{joint_D1(k),arm_A1,Tr2(k),arm_A2,Tr3(k),Alpha3});
    T2eV(:,:,k)=subs(T02,{d1,a1,th2,a2},{joint_D1(k),arm_A1,Tr2(k),arm_A2});
    T1eV(:,:,k)=subs(T01,{d1,a1},{joint_D1(k),arm_A1});
end
%% positions 
X(1,:) = T5eV(1,4,:);
Y(1,:) = T5eV(2,4,:);
Z(1,:) = T5eV(3,4,:);
figure(1);
subplot(2,4,[3,4,7,8]),plot3(X,Y,Z),hold on,plot3(X,Y,Z,'o'),hold on,plot3(0,0,0,'o','Color',[0,1,0]),xlabel('X[m]'),ylabel("Y[m]"),zlabel("Z[m]"),title("Movement of the robotic arm")
grid on

subplot(2,4,6),plot(jointTh5),xlabel("Position number"),ylabel("Angle[deg]"),title("Theta5"),ylim([0 360])
subplot(2,4,5),plot(jointTh3),xlabel("Position number"),ylabel("Angle[deg]"),title("Theta3"),ylim([-180 0])
subplot(2,4,2),plot(jointTh2),xlabel("Position number"),ylabel("Angle[deg]"),title("Theta2"),ylim([-90 90])
subplot(2,4,1),plot(joint_D1),xlabel("Position number"),ylabel("Length[m]"),title("Arm D1"),ylim([-0.1 0.1])
%% PLOT MANIPULATOR


figure(2);
subplot(2,4,6),plot(jointTh5),xlabel("Position number"),ylabel("Angle[deg]"),title("Theta5"),ylim([0 360])
subplot(2,4,5),plot(jointTh3),xlabel("Position number"),ylabel("Angle[deg]"),title("Theta3"),ylim([-180 0])
subplot(2,4,2),plot(jointTh2),xlabel("Position number"),ylabel("Angle[deg]"),title("Theta2"),ylim([-90 90])
subplot(2,4,1),plot(joint_D1),xlabel("Position number"),ylabel("Length[m]"),title("Arm D1"),ylim([-0.1 0.1])

subplot(2,4,[3,4,7,8])
for k=1:number_of_possitions
    number_of_operation = k;          %how the manipulator looks like in given position 
    X_manipulator = [0,T1eV(1,4,number_of_operation),T2eV(1,4,number_of_operation),T3eV(1,4,number_of_operation),T4eV(1,4,number_of_operation),T5eV(1,4,number_of_operation)];
    Y_manipulator = [0,T1eV(2,4,number_of_operation),T2eV(2,4,number_of_operation),T3eV(2,4,number_of_operation),T4eV(2,4,number_of_operation),T5eV(2,4,number_of_operation)];
    Z_manipulator = [0,T1eV(3,4,number_of_operation),T2eV(3,4,number_of_operation),T3eV(3,4,number_of_operation),T4eV(3,4,number_of_operation),T5eV(3,4,number_of_operation)];
    %X_manipulator = [0,T1eV(1,4,number_of_operation),T2eV(1,4,number_of_operation),T3eV(1,4,number_of_operation),T32eV(1,4,number_of_operation),T4eV(1,4,number_of_operation)];
    %Y_manipulator = [0,T1eV(2,4,number_of_operation),T2eV(2,4,number_of_operation),T3eV(2,4,number_of_operation),T32eV(2,4,number_of_operation),T4eV(2,4,number_of_operation)];
    %Z_manipulator = [0,T1eV(3,4,number_of_operation),T2eV(3,4,number_of_operation),T3eV(3,4,number_of_operation),T32eV(3,4,number_of_operation),T4eV(3,4,number_of_operation)];


    figure(2);
    plot3(X_manipulator,Y_manipulator,Z_manipulator,'Color',[1,0,0])
    hold on
    plot3(X_manipulator,Y_manipulator,Z_manipulator,"o",'Color',[1,0,0])
    hold on
    plot3(0,0,0,'o','Color',[0,1,0]),xlabel('X[m]'),ylabel("Y[m]"),zlabel("Z[m]"),title("Movement of the robotic arm")
    hold on 
    plot3(X,Y,Z,'Color',[0,0,1]),hold on,plot3(X,Y,Z,'o')
    grid on 
end
xlim([-0.8 0.8])
ylim([-0.8 0.8])
zlim([-0.8 0.8])
%%
% indication of joint coordinates
% variables: th1,th2 and a3 indicated by ‘1’s
zmie=[[0,1,0,0];[1,0,0,0];[1,0,0,0];[0,0,0,0];[1,0,0,0]];
% a simplified form of the evaluated HT matrices
% for interpretation purpose for a user
%%
T05S=zam(zmie,T05,'th');




%% TASK 4
%% get vector Pa and d1 th2 a3
P3 = [0;0;d4+d5;1];
Pa = T03*P3;

PaS = subs(Pa,{th5},{q5});
PaZ = zam(zmie,Pa,"th")

%%
pw = T05(1:3,3)*(d4+d5);
P = T05(1:3,4);

pa = P - pw;

paS = subs(pa,{th5},{q5});
paZ = zam(zmie,pa,"th")

