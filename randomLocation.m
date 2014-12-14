function [ location ] = randomLocation( location_params, streetNames, buildingNames )
%randomLocation generates a random location string given the desired type 
%of location. location_params is a string containing either a simple street
%address (street name and number) or a building name with a room number

ROAD_NUMBER_FORMAT = {'nn'};
ROAD_FORMAT = {'RR'};
ENDING_FORMAT = {'EE'};
BUILDING_FORMAT = {'BB'};
BUILDING_NUMBER_FORMAT = {'NN'};

ENDING_OPTS = {'Rd', 'St', 'Dr', 'Ct'};

locationPortion = {};
dPCount = 1;
for i=1:length(location_params)
    if (location_params(i) == 'n')
        locationPortion{dPCount} = ROAD_NUMBER_FORMAT{randi(length(ROAD_NUMBER_FORMAT))};
    elseif (location_params(i) == 'R')
        locationPortion{dPCount} = ROAD_FORMAT{randi(length(ROAD_FORMAT))};
    elseif (location_params(i) == 'e')
        locationPortion{dPCount} = ENDING_FORMAT{randi(length(ENDING_FORMAT))};
    elseif (location_params(i) == 'b')
        locationPortion{dPCount} = BUILDING_FORMAT{randi(length(BUILDING_FORMAT))};
    elseif (location_params(i) == 'N')
        locationPortion{dPCount} = BUILDING_NUMBER_FORMAT{randi(length(BUILDING_NUMBER_FORMAT))};
    else
        continue;
    end
    dPCount = dPCount + 1;
end

roadNumberType = find(ismember(locationPortion, ROAD_NUMBER_FORMAT), 1);
roadType = find(ismember(locationPortion, ROAD_FORMAT), 1);
endingType = find(ismember(locationPortion, ENDING_FORMAT), 1);
buildingType = find(ismember(locationPortion, BUILDING_FORMAT), 1);
buildingNumberType = find(ismember(locationPortion, BUILDING_NUMBER_FORMAT), 1);

roadNumber = '';
if (~isempty(roadNumberType))
    randNum = randi(8);
    if (randNum == 8)
        roadNumber = int2str(randi([100,999]));
    elseif (randNum > 1)
        roadNumber = int2str(randi([1000,9999]));
    else
        roadNumber = int2str(randi([10000,99999]));
    end
    roadNumber = strcat(roadNumber, {' '});
end
road = '';
if (~isempty(roadType))
%     streetNames = cell(91670,1);
%     streets = fopen('streetNames.txt','r');
%     i = 1;
%     tline = fgetl(streets);
%     while ischar(tline)
%         streetNames{i} = tline;
%         i = i+1;
%         tline = fgetl(streets);
%     end
%     fclose(streets);
    road = streetNames(randi(length(streetNames)),1);
    road = strcat(road, {' '});
end
ending = '';
if (~isempty(endingType))
    ending = ENDING_OPTS{randi(length(ENDING_OPTS))};
%     add a period after road ending
    if (randi(2) == 1)
        ending = strcat(ending, {'.'});
    end
end

building = '';
if (~isempty(buildingType))
%     buildingNames = cell(50,1);
%     builds = fopen('buildingNames.txt','r');
%     i = 1;
%     tline = fgetl(builds);
%     while ischar(tline)
%         buildingNames{i} = tline;
%         i = i+1;
%         tline = fgetl(builds);
%     end
%     fclose(builds);
    road = buildingNames(randi(length(buildingNames)),1);
    building = strcat(building, {' '});
end
buildingNumber = '';
if (~isempty(buildingNumberType))
    if (randi(2) == 1)
        buildingNumber = int2str(randi([100,499]));
    else
        buildingNumber = int2str(randi([1000,4999]));
    end
end

location = char(strcat(roadNumber, road, ending, building, buildingNumber));
end

