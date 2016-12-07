%Antenna toolbox practice
% Eric Pate

function [Xi,Yi,EmagI,Dvec]=AntennaModelingCore(f0,ant,x,y,lat0,lon0,Number)

%%% Compute E field at points and magnitude
z = 15;
x = x*1e3;        %scale in km, step size
y = y*1e3;
%{
x = (-10:.5:10)*1e3;        %scale in km, step size
y = (-10:.5:10)*1e3;
%}
[X,Y]       = meshgrid(x,y);
TotalPoints = length(x)*length(y);
Points      = zeros(3,TotalPoints);
for m=1:size(X,2)
    index1 = size(X,1)*(m-1);
    index2 = size(X,1)*m;
    Points(:,index1+1:index2) = [X(:,m).'; Y(:,m).'; z*ones(size(X(:,m).'))];
end
E = EHfields(ant, f0, Points);

Emag = zeros(1,TotalPoints);
r    = zeros(1,TotalPoints);
for m=1:TotalPoints
    Emag(m) = norm(E(:,m));
    r(m)    = norm(Points(:,m));
end
Emag  = 20*log10(reshape(Emag,length(y),length(x)));
r     = reshape(r,length(y),length(x));
d_min = min(Emag(:));
d_max = max(Emag(:));
del   = (d_max-d_min)/12;
d_vec = round((d_min:del:d_max));

% Export X/Y/Emag data to function
Xi=X;
Yi=Y;
EmagI=Emag;
Dvec=d_vec;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% plot emag on lat lon

subplot(2,2,Number)
contourf(X*1e-3,Y*1e-3,Emag,d_vec,'showtext','on');
Number=num2str(Number);
title(['Rad Power for ',Number]);
xlabel('lateral (km)');
ylabel('boresight (km)');
c = colorbar;
set(get(c,'title'),'string','dB');


%lat0 =  33.7756;
%lon0 = -84.3963;
h0 = 0;
az = -180;
xyrot = wrapTo180(az - 90);

levelList = d_vec(2:end);
[contourLines, contourPolygons] = geocontourxy( ...
    X,Y,Emag,lat0,lon0,h0,'LevelList',levelList,'XYRotation',xyrot);
% Set up base map.
[latlim, lonlim] = geoquadline( ...
    contourPolygons.Latitude, contourPolygons.Longitude);

latlim = latlim + [-.01 .01];
lonlim = lonlim + [-.01 .01];

states = shaperead('usastatelo.shp', ...
    'BoundingBox',[lonlim' latlim'],'UseGeoCoords',true);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Map GeoMap
% Set up base map.
%{
figure
usamap(latlim, lonlim)
geoshow(states,'FaceColor',[0.8 0.8 0.8])

% Overlay contour polygons and antenna location.
cmap = parula(length(contourPolygons));
for k = 1:length(contourPolygons)
    lat = contourPolygons(k).Latitude;
    lon = contourPolygons(k).Longitude;
    geoshow(lat,lon,'Display','polygon', ...
        'FaceColor',cmap(k,:),'FaceAlpha',0.5,'EdgeColor','none')
end

% Overlay contour lines.
geoshow(contourLines.Latitude,contourLines.Longitude,'Color','black')

% Add a marker to show the antenna location.
p = geopoint(lat0,lon0);
p.Description = 'System Location';
geoshow(p,'Marker','d','MarkerSize',10,'LineWidth',2, ...
    'MarkerEdgeColor','k','MarkerFaceColor','g')

% Show system location.
geoshow(p,'Marker','d','MarkerSize',10,'LineWidth',2, ...
    'MarkerEdgeColor','k','MarkerFaceColor','g')

% Add title.
title(['Filled Contours Projected on Map for ',Number])
%}
% Add a marker to show the antenna location.
p = geopoint(lat0,lon0);
p.Description = 'System Location';
cmap = parula(length(contourPolygons));
wmpolygon(contourPolygons,'Overlayname','Antenna Power 1', ...
    'FeatureName','Antenna Contour Polygons',  ...
    'Description','Antenna Contour Polygon', ...
    'FaceColor',cmap,'FaceAlpha',0.3);
wmmarker(p,'Description','System Location','Overlayname','System Location')

  
end
