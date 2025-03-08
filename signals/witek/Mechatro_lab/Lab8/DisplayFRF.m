function [FRF,Freq] = DisplayFRF(FRFresult,XYZ,dataType)
% [FRF,Freq] = DisplayFRF(FRFresult,XYZ,dataType)
%
% Function to display Frequency Response Function from the simulation using Partial
% Differential Equation Toolbox
% Input variables:
% - FRFresult - result object of the frequency respone simulation
% - XYZ - 3-element vector of coordinates, from which the response should
% be read
% - dataType - quantity to be displayed; options: 'diplacement',
% 'velocity', 'acceleration'

XN = XYZ(1);
YN = XYZ(2);
ZN = XYZ(3);
eps = 1e-3;

indM = find(FRFresult.Mesh.Nodes(1,:)>XN-eps & FRFresult.Mesh.Nodes(1,:)<XN+eps & ...
    FRFresult.Mesh.Nodes(2,:)>YN-eps & FRFresult.Mesh.Nodes(2,:)<YN+eps & ...
    FRFresult.Mesh.Nodes(3,:)>ZN-eps & FRFresult.Mesh.Nodes(3,:)<ZN+eps);

Freq = FRFresult.SolutionFrequencies/2/pi;

switch dataType
    case 'displacement'
        DatX = FRFresult.Displacement.ux(indM,:);
        DatY = FRFresult.Displacement.uy(indM,:);
        DatZ = FRFresult.Displacement.uz(indM,:);
    case 'velocity'
        DatX = FRFresult.Velocity.vx(indM,:);
        DatY = FRFresult.Velocity.vy(indM,:);
        DatZ = FRFresult.Velocity.vz(indM,:); 
    case 'acceleration'
        DatX = FRFresult.Acceleration.ax(indM,:);
        DatY = FRFresult.Acceleration.ay(indM,:);
        DatZ = FRFresult.Acceleration.az(indM,:); 
    otherwise
        disp('wrong data type')
        return       
end

FRF(:,1) = DatX;
FRF(:,2) = DatY;
FRF(:,3) = DatZ;

end

