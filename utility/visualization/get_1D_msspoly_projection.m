function projlims=  get_1D_msspoly_projection(p,x,l,dproj,varargin)
% plot_2D_msspoly_contour(p,x,l,'property1',value1,'property2',value2,...)
%
% Given an msspoly p in the 2D variable x, plot its l-level set. If l is
% not provided, then l = 0 is used as the default. After the 3 default
% inputs, this function takes in the regular property/value pairs of the
% MATLAB default contour function. In addition, you can provide the
% following properties:
%   Offset     a 2-by-1 vector (x,y) to shift the origin to
%   Scale      a scalar value to scale the size of the plot by
%   FillColor  a color in usual matlab plotting syntax to fill the contour
    
%% parse inputs
projlims = NaN;

if nargin<4
    varargin = {};
    dproj = 1;
    if nargin < 3
        l = 1 ;
    end
end


d = length(x);
    % create default inputs
    Offset = zeros(d,1) ;
    Scale = ones(d,1) ;

    % iterate through varargin to find Offset and Scale
    varargin_new = {} ;
    idx_new = 1 ;
    for idx = 1:2:length(varargin)
        switch varargin{idx}
            case 'Offset'
                Offset = varargin{idx+1} ;
            case 'Scale'
                Scale = varargin{idx+1} ;
            otherwise
                varargin_new{idx_new} = varargin{idx} ;
                varargin_new{idx_new+1} = varargin{idx+1} ;
                idx_new = idx_new + 2 ;
        end
    end

%% set up for plotting
    % set up grid for plotting
    
    if d == 2
        x_vec = linspace(-1,1,100) ;
        
        [X1,X2] = meshgrid(x_vec,x_vec) ;
        X1 = X1(:)';
        X2 = X2(:)';
        
        X = [X1; X2] ;
        
        % create msspoly surface and find indexs above level sets
        P = full(msubs(p,x,X));
        Idx_in = find(P >= l);
        
        if ~isempty(Idx_in)
            % scale and shift for plotting
            X1 = Scale(1)*(X1) + Offset(1) ;
            X2 = Scale(2)*(X2) + Offset(2) ;
            
            if dproj == 1
                projlims = [X1(Idx_in(1)),X1(Idx_in(end))];
            elseif dproj == 2
                projlims = [X2(Idx_in(1)),X2(Idx_in(end))];
            end
            
%             if dplot == 1
%                 ylims = get(gca,'ylim');
%                 Xbox = make_box([diff(projlims),diff(ylims)])+[mean(projlims);0];
%                 fill(Xbox(1,:),Xbox(2,:),FillColor,varargin_new{:})
%             elseif dplot == 2
%                 xlims = get(gca,'xlim');
%                 Xbox = make_box([diff(xlims),diff(projlims)])+[0;mean(projlims)];
%                 fill(Xbox(1,:),Xbox(2,:),FillColor,varargin_new{:})
%                 
%             end
        end
    else
        warning('not configured for dim other than 2 rn')
    end
    
    
  
end