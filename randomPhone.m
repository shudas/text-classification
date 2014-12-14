function [ phoneNumber ] = randomPhone( TYPE , PAREN, SEPARATOR )

%TYPE is EXTEND, NPA, or NONE
%PAREN is TRUE, SPACED, or FALSE
%SEPARATOR is DASH, PERIOD, SPACE, SLASH, or NONE

%EXTEND means 11 digit number (starts with 1)
%NPA means 10 digit number (with area code)
%NONE means no area code

%PAREN represents if there are parenthesis around area code or not
    
    Extension = num2str(1);
    Area_Code = getRandNPA();
    CO_Code = getRandCO();
    Station_Code = getRandStation();
    
    if (strcmp(PAREN, 'TRUE'))
        Area_Code = ['(', Area_Code, ')'];
    elseif (strcmp(PAREN, 'SPACED'))
        Area_Code = ['( ', Area_Code, ' )'];
    else
        assert(strcmp(PAREN, 'FALSE'), 'PAREN must be TRUE, SPACED, or FALSE in randomPhone');
    end
    
    if (strcmp(SEPARATOR, 'DASH'))
        SEP1 = '-';
        SEP2 = '-';
    elseif (strcmp(SEPARATOR, 'END_DASH'))
        SEP1 = ' ';
        SEP2 = '-';    
    elseif (strcmp(SEPARATOR, 'PERIOD'))
        SEP1 = '.';
        SEP2 = '.';
    elseif (strcmp(SEPARATOR, 'SPACE'))
        SEP1 = ' ';
        SEP2 = ' ';
    elseif (strcmp(SEPARATOR, 'NONE'))
        SEP1 = '';
        SEP2 = '';
    elseif (strcmp(SEPARATOR, 'SPACED_DASH'))
        SEP1 = ' - ';
        SEP2 = ' - ';
    elseif (strcmp(SEPARATOR, 'SLASH'))
        SEP1 = '/';
        SEP2 = '/';
    else
        assert(false, 'Not a valid phone number separator');
    end
    
    if (strcmp(TYPE, 'EXTEND'))
        phoneNumber = [Extension, SEP1, Area_Code, SEP1, CO_Code, SEP2, Station_Code];
    elseif (strcmp(TYPE, 'NPA'))
        phoneNumber = [Area_Code, SEP1, CO_Code, SEP2, Station_Code];
    elseif (strcmp(TYPE, 'NONE'))
        phoneNumber = [CO_Code, SEP2, Station_Code];
    else
        assert(false, 'Not a valid phone number type');
    end
end

function [ randNPA ] = getRandNPA( )
% returns a number between 200 and 999
% not 100% true for american numbers
    randNPA = sprintf('%03d', randi(800) + 199);
end

function [ randCO ] = getRandCO( )
% returns a valid CO number
% first digit is between 2 and 9
% last two digits cannot be 11


% first digit is between 2 and 9
    firstDigit = randi(8) + 1;
% second digit is between 1 and 9
    secondDigit = randi(10) - 1;

% second and third digit cannot both be 1
    if (secondDigit ~= 1)
        thirdDigit = randi(10) - 1;
    else
        thirdDigit = randi(9);
        if (thirdDigit == 1)
            thirdDigit = 0;
        end
    end
    
    randCO = num2str(firstDigit * 100 + secondDigit * 10 + thirdDigit);
        
end


function [ randStation ] = getRandStation ( )
% returns a random integer between 0 and 9999

    randStation = sprintf('%04d', randi(10000) - 1);
    
end