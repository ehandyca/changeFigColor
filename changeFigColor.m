%% Change colors of figure
% Eric Handy
% 2024/06/05
function fig = changeFigColor(varargin)
% Changes the color of a figure to a specified color. Can change figure
% color, axes colors, text color, and data color. Also changes default
% interpreter to LaTeX.
% -------------------------------------------------------------------------
% Sintax:
%
% changeFigColor(image_path);
% changeFigColor(mat_figure_path);
% changeFigColor(figure);
% changeFigColor(figure,'options');
% changeFigColor(__, figColor);
% changeFigColor(__, figColor, txtColor);
% changeFigColor(__, 'fontsize', 20);
% changeFigColor(__, 'invertDataColor');
% changeFigColor(__, 'invertColormap');
% changeFigColor(__, 'invertColormap', 'vorticity');
% changeFigColor(__, 'textInterpreter', interpreter);
% figure = changeFigColor(__);
% -------------------------------------------------------------------------
% Description:
%
% changeFigColor('image_file_path') : Inverts color scheme to negative
%           scheme of the image file specified by 'image_file_path'.
%           Inverted image will be saved in the same directory as the
%           original file with the name: "originalFileName_inverted.ext".
%           If the file specified is a ".fig" file, additional
%           modifications can be implemented through the 'options'
%           arguments.  ".fig" files with figColor set to black will be
%           renamed as "originalFileName_inverted.fig", while ".fig" files
%           with 'figColor' set to any other color will be saved as
%           "originalFileName_recolored.fig".
% 
% changeFigColor() : Changes color of active figure to white scheme.
%
% changeFigColor('options') : Applies changes specified by 'options'.
%
% -------------------------------------------------------------------------
% 'options':
%
% changeFigColor(__, figColor) : Sets color of active figure to color
%           specified by 'figColor' (RGB vector or single-character color
%           string). Axis line colors are set to white if 'figColor' is
%           black or mean(validatecolor(figColor)) < 0.25. Otherwise axis
%           colors will match 'txtColor' when specified.
%           If mean(validatecolor(figColor)) < 0.25 or color specified by
%           'figColor' is black, axes with multiple y-axis (yyaxis plots)
%           will have their axis color inverted.
%           If mean(validatecolor(figColor)) < 0.25 and 'textColor' is not
%           specified, 'textColor' will be set to white.
%
% changeFigColor(__, figColor, txtColor) : Sets color of active figure to
%           color specified by 'figColor' (RGB vector or single-character
%           color string) and changes text color to color specified by
%           'txtColor' (RGB vector or single-character color string).
%           If mean(validatecolor(figColor)) >= 0.25 and 'textColor' is not
%           specified, 'textColor' will be the inverted color specified by
%           'figColor'.
%
% changeFigColor(__, figure) : Changes colors of passed figure handle.
%
% changeFigColor(__, 'fontsize', ##) : Name-value argument to set the text
%           font size. Value argument must be a numeric positive integer.
%
% changeFigColor(__, 'textInterpreter', 'interpreter') : Name-value
%           argument to define text interpreter. Can be 'latex', 'tex' or
%           'none'. Default interpreter is 'latex'.
%
% changeFigColor(__, 'invertDataColor') : Inverts color of data plotted in
%           active figure. If a plot has a colormap associated with it,
%           'invertDataColor' will not affect it unless 'invertColormap' is
%           passed as an additional input argument.
%
% changeFigColor(__, 'invertColormap') : Inverts active figure colormap.
%
% fig = changeFigColor(__) : Returns figure handle.
%
% -------------------------------------------------------------------------
% Examples:
%
% [1]  changeFigColor("image_path.png");
%           Inverts image color and saves as "image_path_inverted.png"
% [2]  changeFigColor("image_path.jpeg");
%           Inverts image color and saves as "image_path_inverted.jpeg"
% [3]  changeFigColor("image_path.fig");
%           Inverts image color and saves as "image_path_inverted.fig"
% [4]  changeFigColor("image_path.fig", 'b', [0,2,1], 'invertDataColor');
%           Changes image color to blue and text color to sepcified color, while inverting plot colors and saves as "image_path_recolored.fig"
% [5]  changeFigColor();
%           Sets color of active figure to default white. Sets interpreter to LaTeX.
% [6]  changeFigColor(figure);
%           Sets color of specified figure to default white. Sets interpreter to LaTeX.
% [7]  changeFigColor('k');
%           Sets color of active figure to black, setting text and axis colors to white. Sets interpreter to LaTeX.
% [8]  changeFigColor([0,0,0.1]);
%           Sets color of active figure to specified color, and inverts text and axis colors. Sets interpreter to LaTeX.
% [9]  changeFigColor('c', [1,1,0.2]);
%           Sets color of active figure to cyan, and text and axis to specified color. Sets interpreter to LaTeX.
% [10] changeFigColor('g', 'b', figure);
%           Sets color of specified figure to green, and text and axis to blue. Sets interpreter to LaTeX.
% [11] changeFigColor([], figure, 'y');
%           Sets color of specified figure to default white, and text and axis to yellow. Sets interpreter to LaTeX.
% [12] changeFigColor([], figure, 'y','fontsize',20);
%           Sets color of specified figure to default white, and text and axis to yellow. Sets interpreter to LaTeX and fontsize to 20.
% [13] changeFigColor('invertDataColor');
%           Sets color of active figure to default white and inverts plotted data object colors. Sets interpreter to LaTeX.
% [14] changeFigColor('invertColormap');
%           Sets color of active figure to default white and inverts active colormap. Sets interpreter to LaTeX.
% [15] changeFigColor('k','invertColormap','vorticity');
%           Sets color of active figure to black and inverts active colormap to Red-Black-Blue scheme for vorticity contours. Sets interpreter to LaTeX.
% [16] changeFigColor(figure, 'invertDataColor', 'invertColormap');
%           Sets color of specified figure to default white, inverts plotted data object colors, and inverts active colormap. Sets interpreter to LaTeX.
% [17] fig = changeFigColor('k', figure, 'textInterpreter', 'tex', 'invertDataColor');
%           Sets color of specified figure to black, changing text and axis colors to white. Sets interpreter to TeX. Inverts plotted data object colors.
% -------------------------------------------------------------------------
% Version 1.0.0
% Eric Handy-Cardenas, 2024/06/05
%
% Version 2.0.0
% - Added capability to invert figure line colors and colormap.
% - Additional bug fixes.
% Eric Handy-Cardenas, 2024/11/20
%
% Version 3.0.0
% - Added capability to invert image files (png, jpeg, tiff, etc.).
% - Added option to use a traditional Red-Black-Blue scheme for vorticity contours when inverting the colormap.
% - Additional bug fixes.
% Eric Handy-Cardenas, 2024/12/02
%
% Version 3.1.0
% - Added capability to read-in ".fig" files.
% - Additional bug fixes.
% Eric Handy-Cardenas, 2024/12/04
% -------------------------------------------------------------------------

% Short color names:
colors = {'r','g','b','c','m','y','k','w'};
colorflag = 0; % to identify the first color argument or the second

% Parse through inputs
skipNext = 0;
for inptNum = 1:length(varargin)
    if skipNext == 1 % skip to next in case a name-value argument was just evaluated
        skipNext = 0;
        continue
    else
        var_option = varargin{inptNum};
        
        % Evaluate for figure object --------------------------------------
        try objtype = var_option.Type;
            switch objtype
                case 'figure'
                    fig = var_option;
                otherwise
                    error(['Unidentified input object type: "',var_option.Type,'"',newline,'Expected "figure" object.'])
            end

        catch

            % Check for numeric color input -------------------------------
            if isnumeric(var_option)
                if all(size(var_option)==[1,3])
                    if colorflag == 0
                        figColor = var_option;
                        colorflag = 1;
                    else
                        txtColor = var_option;
                    end
                else
                    error('Colors must be specified as single-letter strings or RGB vectors.')
                end

            % Check for string color input --------------------------------
            elseif any(strcmp(var_option,colors))
                if colorflag == 0
                    figColor = var_option;
                    colorflag = 1;
                else
                    txtColor = var_option;
                end

            % Evaluate for file -------------------------------------------
            elseif isfile(var_option)
                [filepath, name, ext] = fileparts(var_option);

                % Evaluate for ".fig" file and load -----------------------
                if strcmp(ext,'.fig')
                    fig = openfig(var_option);
                    save_figure_flag = 1;

                % For any other image filetype, invert and save -----------
                elseif isempty(imformats(ext(2:end)))
                    error(['Unsupported image file format: ',ext,newline,'For supported image file formats check "imread()" documentation.'])
                else
                    [A,cmap] = imread(var_option);
                    if isempty(cmap)
                        [A,cmap] = rgb2ind(A,256);
                    end
                    cmapNew = abs(1-cmap);
                    imwrite(A,cmapNew,fullfile(filepath,append(name,'_inverted',ext)));
    
                    if length(varargin) > 1
                        warning('Only one input argument is accepted when passing an image file. Further inputs ignored.')
                        break;
                    end
                end

            % Evaluate for name-value arguments ---------------------------
            else    
                switch var_option
                    case 'fontsize'
                        font_size = varargin{inptNum+1};
                        skipNext = 1; % ignore next argument and parse following input

                    case 'textInterpreter'
                        TextInterpreter = varargin{inptNum+1};
                        skipNext = 1; % ignore next argument and parse following input

                    case 'invertColormap'
                        icmap = 1;
                        try varargin{inptNum+1}; % check for an additional input
                            if ~isnumeric(varargin{inptNum+1})
                                if strcmp(varargin{inptNum+1},'vorticity')
                                    ivort = 1;
                                    skipNext = 1; % ignore next argument and parse following input
                                end
                            end
                        catch
                            continue;
                        end
    
                % Evaluate for name-only arguments ------------------------
                    case 'invertDataColor'
                        idc = 1;
    
                    otherwise
                        warning(['Unidentified input argument: "',var_option,'"',newline,'Value will be ignored.'])
                end
            end
        end
    end
end


% Check if figColor is specified, otherwise default to white scheme
if ~exist('figColor','var') || isempty(figColor)
    figColor = 'w';
end

% Check if txtColor is specified, otherwise choose appropriate color
if ~exist('txtColor','var') || isempty(txtColor)
    if strcmp(figColor,'k') || mean(figColor) < 0.25
        txtColor = 'w';
    else % invert figure color to obtain maximum contrast
        colorTemp = validatecolor(figColor);
        txtColor = abs(1-colorTemp);
    end
end

% Check for invertDataColor (idc) flag 
if ~exist('idc','var') || isempty(idc)
    idc = 0;
end

% Check for invertColormap (icmap) flag 
if ~exist('icmap','var') || isempty(icmap)
    icmap = 0;
end

% Check for invert Vorticity (ivort) flag
if ~exist('ivort','var') || isempty(ivort)
    ivort = 0;
end

% If figure object is not passed, operate on active figure
if ~exist('fig','var') || isempty(fig)
    fig = gcf;
end

% Check interpreter argument
if ~exist('TextInterpreter','var') || isempty(TextInterpreter)
    % default interpreter is latex:
    TextInterpreter = 'latex';
elseif ~strcmp(TextInterpreter,'latex') && ~strcmp(TextInterpreter,'tex') && ~strcmp(TextInterpreter,'none')
    error('Invalid text interpreter. Must be "tex" , "latex", "none" or empty.')
end

% Check for fontsize argument
if ~exist('font_size','Var') || isempty(font_size)
    font_size = 'default';
end


% For Figures ----------------------------------------------------------
% Change color of figure
set(fig,'color',figColor);

% Get figure children
ax = fig.Children;

% Change color of all axes by identifying the appropriate class object
for axnum = 1:length(ax)
    objType = ax(axnum).Type;

    switch objType

        % For Axis obj:
        case 'axes'
            set(ax(axnum),'color',figColor,'Xcolor',txtColor,'Zcolor',txtColor, ...
                'TickLabelInterpreter',TextInterpreter,'fontsize',font_size);
            
            numRuler = length(ax(axnum).YAxis);
            switch numRuler % in case of multiple y axes
                case 1
                    ax(axnum).YLabel.Interpreter = TextInterpreter;
                    ax(axnum).YAxis.Color = txtColor;

                    % Invert color of data
                    if idc == 1
                        invertColors(ax(axnum),icmap);
                    end

                case 2 % for two y-axes plotted using yyaxis

                    for num = 1:numRuler % invert axes colors
                        if idc == 1 || strcmp(figColor,'k') || mean(validatecolor(figColor)) < 0.25
                            oldAxColor = ax(axnum).YAxis(num).Color;
                            ax(axnum).YAxis(num).Color = abs(1 - oldAxColor); % inverts the set color
                        end
                        ax(axnum).YAxis(num).Label.Interpreter = TextInterpreter;
                    end

                    % Invert color of data
                    if idc == 1
                        yyaxis(ax(axnum),'right'); axTemp = gca; % activate left y-axis
                        invertColors(axTemp,icmap);
                        yyaxis(ax(axnum),'left'); axTemp = gca; % active right y-axis
                        invertColors(axTemp,icmap);
                    end

                otherwise
                    disp('Something went wrong')
            end

            ax(axnum).XLabel.Interpreter = TextInterpreter;
            ax(axnum).ZLabel.Interpreter = TextInterpreter;
            ax(axnum).Title.Interpreter = TextInterpreter;
            ax(axnum).Title.Color = txtColor;

        % For legend obj:
        case 'legend'
            set(ax(axnum),'TextColor',txtColor,'EdgeColor',txtColor,'Color',figColor,...
                'Interpreter',TextInterpreter,'fontsize',font_size);
            ax(axnum).Title.Interpreter = TextInterpreter;
            ax(axnum).Title.Color = txtColor;

        % For colorbar obj:
        case 'colorbar'
            set(ax(axnum),'Color',txtColor,...
                'TickLabelInterpreter',TextInterpreter,'fontsize',font_size);
            ax(axnum).Label.Interpreter = TextInterpreter;

        % For subplottext obj:
        case 'subplottext'
            set(ax(axnum),'Color',txtColor,...
                'Interpreter',TextInterpreter,'fontsize',font_size);
        otherwise
            warning(['Unidentified Object Type: "',objType,'"']);
    end

end

% Invert colormap ---------------------------------------------------------
% POTENTIAL BUG: if a figure has multiple colormaps and the colormap
% inversion optionis enabled, all colormaps will be changed to that of the
% last subplot.
if icmap == 1
    cmapOld = colormap;
    if ivort == 1
        % Build a negative vorticity map from default Matlab colormaps

        % > Option 1:
        % cmapPos = hot(255);
        % cmapNeg = abs(1-hot(255));
        % 
        % cmapNew = abs(1-[cmapPos(129:end,:); 1,1,1; cmapNeg(1:127,:)]);
        % colormap(cmapNew(round(linspace(1,size(cmapNew,1),size(cmapOld,1))),:));

        % > Option 2:
        cmapOld = colormap;
        cmapPos = flipud(hot(255));
        cmapNeg = flipud(abs(1-hot(255)));
        cmapNew = abs(1-flipud([cmapNeg(111:end,:); ones(15,3); cmapPos(1:end-110,:)]));
        colormap(cmapNew(round(linspace(1,size(cmapNew,1),size(cmapOld,1))),:));

    else
        cmapNew = abs(1-cmapOld);
        colormap(cmapNew);
    end
end

% Save figure (if loaded from a ".fig" file directly) ---------------------
if exist('save_figure_flag','var') && ~isempty(save_figure_flag)
    if save_figure_flag == 1
        if strcmp(figColor,'k') || mean(validatecolor(figColor)) == 0
            saveas(fig,fullfile(filepath,append(name,'_inverted',ext)));
        else
            saveas(fig,fullfile(filepath,append(name,'_recolored',ext)));
        end
    end
end

% Invert figure colors function -------------------------------------------
function invertColors(axObject,icmap)
    for plotObj = 1:length(axObject.Children)
        switch axObject.Children(plotObj).Type

            case 'scatter'
                % Invert marker edge colors:
                    oldMrkEdgeColor = axObject.Children(plotObj).MarkerEdgeColor;
                    if ~strcmp(oldMrkEdgeColor,'none')
                        oldMrkEdgeColor = validatecolor(oldMrkEdgeColor);
                        newMrkEdgeColor = abs(1 - oldMrkEdgeColor);
                        axObject.Children(plotObj).MarkerEdgeColor = newMrkEdgeColor;
                    end

                % Invert marker face colors:
                    oldMrkFaceColor = axObject.Children(plotObj).MarkerFaceColor;
                    if ~strcmp(oldMrkFaceColor,'flat')
                        oldMrkFaceColor = validatecolor(oldMrkFaceColor);
                        newMrkFaceColor = abs(1 - oldMrkFaceColor);
                        axObject.Children(plotObj).MarkerFaceColor = newMrkFaceColor;
                    end

                % Invert CData:
                    oldCData = axObject.Children(plotObj).CData;
                    newCData = abs(1 - oldCData);
                    axObject.Children(plotObj).CData = newCData;

            case 'line'
                % Invert general data color:
                oldColor = validatecolor(axObject.Children(plotObj).Color);
                newColor = abs(1 - oldColor);
                axObject.Children(plotObj).Color = newColor;

                % Invert marker edge color:
                oldMrkEdgeColor = axObject.Children(plotObj).MarkerEdgeColor;
                if ~strcmp(oldMrkEdgeColor,'auto') && ~strcmp(oldMrkEdgeColor,'none')
                    oldMrkEdgeColor = validatecolor(oldMrkEdgeColor);
                    newMrkEdgeColor = abs(1 - oldMrkEdgeColor);
                    axObject.Children(plotObj).MarkerEdgeColor = newMrkEdgeColor;
                end

                % Invert marker face color:
                oldMrkFaceColor = axObject.Children(plotObj).MarkerFaceColor;
                if ~strcmp(oldMrkFaceColor,'auto') && ~strcmp(oldMrkFaceColor,'none')
                    oldMrkFaceColor = validatecolor(oldMrkFaceColor);
                    newMrkFaceColor = abs(1 - oldMrkFaceColor);
                    axObject.Children(plotObj).MarkerFaceColor = newMrkFaceColor;
                end

            case 'polygon'
                % Invert polygon face edge:
                oldEdgeColor = axObject.Children(plotObj).EdgeColor;
                if ~strcmp(oldEdgeColor,'auto') && ~strcmp(oldEdgeColor,'none')
                    oldEdgeColor = validatecolor(oldEdgeColor);
                    newEdgeColor = abs(1 - oldEdgeColor);
                    axObject.Children(plotObj).EdgeColor = newEdgeColor;
                end

                % Invert polygon face color:
                oldFaceColor = axObject.Children(plotObj).FaceColor;
                if ~strcmp(oldFaceColor,'auto') && ~strcmp(oldFaceColor,'none')
                    oldFaceColor = validatecolor(oldFaceColor);
                    newFaceColor = abs(1 - oldFaceColor);
                    axObject.Children(plotObj).FaceColor = newFaceColor;
                end

            case 'contour'
                if icmap ~= 1
                    % NOTE: colormap inversion happens outside this function independently
                    % POTENTIAL BUG: if a figure has multiple colormaps and
                    % the colormap inversion option is enabled, all colormaps
                    % will be changed to that of the last subplot.
                    warning('Option "invertColormap" not enabled for active colormap.')
                end

            case 'quiver'
                % Invert general data color:
                oldColor = axObject.Children(plotObj).Color;
                newColor = abs(1 - oldColor);
                axObject.Children(plotObj).Color = newColor;

                % Invert marker edge color:
                oldMrkEdgeColor = axObject.Children(plotObj).MarkerEdgeColor;
                if ~strcmp(oldMrkEdgeColor,'auto') && ~strcmp(oldMrkEdgeColor,'none')
                    oldMrkEdgeColor = validatecolor(oldMrkEdgeColor);
                    newMrkEdgeColor = abs(1 - oldMrkEdgeColor);
                    axObject.Children(plotObj).MarkerEdgeColor = newMrkEdgeColor;
                end

                % Invert marker face color:
                oldMrkFaceColor = axObject.Children(plotObj).MarkerFaceColor;
                if ~strcmp(oldMrkFaceColor,'auto') && ~strcmp(oldMrkFaceColor,'none')
                    oldMrkFaceColor = validatecolor(oldMrkFaceColor);
                    newMrkFaceColor = abs(1 - oldMrkFaceColor);
                    axObject.Children(plotObj).MarkerFaceColor = newMrkFaceColor;
                end

            case 'errorbar'
                oldColor = axObject.Children(plotObj).Color;
                newColor = abs(1 - oldColor);
                axObject.Children(plotObj).Color = newColor;

                % Invert marker edge color:
                oldMrkEdgeColor = axObject.Children(plotObj).MarkerEdgeColor;
                if ~strcmp(oldMrkEdgeColor,'auto') && ~strcmp(oldMrkEdgeColor,'none')
                    oldMrkEdgeColor = validatecolor(oldMrkEdgeColor);
                    newMrkEdgeColor = abs(1 - oldMrkEdgeColor);
                    axObject.Children(plotObj).MarkerEdgeColor = newMrkEdgeColor;
                end

                % Invert marker face color:
                oldMrkFaceColor = axObject.Children(plotObj).MarkerFaceColor;
                if ~strcmp(oldMrkFaceColor,'auto') && ~strcmp(oldMrkFaceColor,'none')
                    oldMrkFaceColor = validatecolor(oldMrkFaceColor);
                    newMrkFaceColor = abs(1 - oldMrkFaceColor);
                    axObject.Children(plotObj).MarkerFaceColor = newMrkFaceColor;
                end

            otherwise
                warning(['Plot type: "',axObject.Children(plotObj).Type,'" not supported.'])
        end
    end
end

end













