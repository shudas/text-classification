%pGarbage is a number between 0 and 1 inclusive
%proportionChange is a number between 0 and 1 inclusive
%the number of characters to change is:
%ceil( proportionChange * length(inputString) )
function noiseString = add_Noise(inputString, pGarbage, proportionChange)
noiseString = inputString;
num = randi([0 99])/100;
population = [33:64 33:64 65:90 91:96 91:96 97:122 123:126 123:126];
if num < pGarbage
	noiseString = char(randsample(population, length(inputString)));
else
    numChange = ceil(proportionChange * length(inputString)); 
    changeIndex = randsample(length(inputString), numChange);
    changeChar = randsample(population, numChange);
    for i = 1:numChange
    	noiseString(changeIndex(i)) = char(changeChar(i));
    end
end