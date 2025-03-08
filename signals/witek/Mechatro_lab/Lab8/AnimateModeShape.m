function AnimateModeShape(Model,ModeNumber,frames)
% AnimateModeShape(Model,ModeNumber,frames)
% Function used to display and animate mode shapes obtained using Partial
% Differential Equation Toolbox
% Input variables:
% - Model - analysis model used for simulation
% - ModeNumber - number of a mode to be displayed
% - frames - number of frames per second for the animation

% Animation parameters
scale = 0.01;

deformedModel = createpde('structural','modal-solid');

% Undeformed mesh data
nodes = Model.Mesh.Nodes;
elements = Model.Mesh.Elements;

omega = Model.NaturalFrequencies(ModeNumber);
timePeriod = 2*pi./Model.NaturalFrequencies(ModeNumber);

curr_frame = 0;
hWaitbar = waitbar(0, 'Frame 1', 'Name', 'Solving problem','CreateCancelBtn','delete(gcbf)');
figure('units','normalized','outerposition',[0 0 0.7 0.7]);
while 1
    curr_frame = curr_frame+1;
    if curr_frame >frames
        curr_frame = 1;
    end
    
    modalDeformation = [Model.ModeShapes.ux(:,ModeNumber)';
            Model.ModeShapes.uy(:,ModeNumber)';
            Model.ModeShapes.uz(:,ModeNumber)'];
        
    modalDeformationMag = sqrt(modalDeformation(1,:).^2 + ...
            modalDeformation(2,:).^2 + ...
            modalDeformation(3,:).^2);
        
    % Compute nodal locations of deformed mesh.
    pseudoTimeVector = linspace(0,timePeriod,frames);
    nodesDeformed = nodes + scale.*modalDeformation*sin(omega.*pseudoTimeVector(curr_frame));
    
    % Construct a deformed geometric shape using displaced nodes and
    % elements from unreformed mesh data.
    geometryFromMesh(deformedModel,nodesDeformed,elements);    
    
    % Plot the deformed mesh with magnitude of mesh as color plot.
    pdeplot3D(deformedModel,'ColorMapData', modalDeformationMag)
    title(sprintf(['Postac drgan %d\n', ...
        'Czestotliwosc = %g Hz'], ...
        ModeNumber,omega/2/pi));


    % Remove axes triad and colorbar for clarity
    colorbar
    axis([-0.1,0.1,-0.1,0.1,-0.02,0.02]);
    delete(findall(gca,'type','quiver'));
    
    % Remove deformed geometry to reuse to model for next mode.
    deformedModel.Geometry = [];
        
    if ~ishandle(hWaitbar)
        % Stop the if cancel button was pressed
        disp('Stopped by user');
        break;
    else
        % Update the wait bar
        waitbar(curr_frame/frames,hWaitbar, ['Frame ' num2str(curr_frame)]);
    end

end
% close all;

end

