function [FRFarea,ModeShape,Xl,Yl,Zl] = DisplayMode(resFreq,modelFR,Zlayer,Axis,fc)
% [FRFarea,ModeShape,Xl,Yl,Zl] = DisplayMode(resFreq,modelFR,Zlayer,Axis,fc)
%
% Function to extract FRFs from the model at layer Z=Zlayer (FRFarea), and mode shape for specific frequency (ModeShape) from results of the simulation using Partial
% Differential Equation Toolbox. (Xl,Yl,Zl) correspond to coordiantes of
% mode ModeShape or FRF set FRFarea
% Input variables:
% - resFreq - result object of the frequency respone simulation
% - modelFR - analysis model used for the frequency respone simulation
% - Zlayer - Z-coordinate at which the slice should be taken
% - Axis - axis at which the motion should be extracted; options: (1 - X, 2 - Y, 1 - Z)
% - fc - frequency at which the ModeShape should be extracted

ZN = Zlayer;
eps = 1e-5;
% search for indices corresponding to the slice layer at Z=ZN
indMeas = find(modelFR.Mesh.Nodes(3,:)>ZN-eps & modelFR.Mesh.Nodes(3,:)<ZN+eps);

% vectors corresponding to the XYZ coordiantes of the model
Xv = modelFR.Mesh.Nodes(1,:);
Yv = modelFR.Mesh.Nodes(2,:);
Zv = modelFR.Mesh.Nodes(3,:);

FRFarea = zeros(length(resFreq.SolutionFrequencies),length(indMeas));

for i = 1:length(indMeas)
    ind = indMeas(i);
    XYZ = [Xv(ind),Yv(ind),Zv(ind)];
    dataType = 'displacement';
    [FRF,Freq] = DisplayFRF(resFreq,XYZ,dataType);
    [~,fc_ind] = min(abs(Freq - fc));
    FRFarea(:,i) = squeeze(FRF(:,Axis));
end
ModeShape = squeeze(FRFarea(fc_ind,:));
Xl = Xv(indMeas);
Yl = Yv(indMeas);
Zl = Zv(indMeas);

