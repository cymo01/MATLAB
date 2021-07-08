% key exclude words

clear;
pdfFolders = {'\\dom1\Core\Dept\FPS\Groups\KVG\College Resumes\2021\02 February 1-23' ...
    '\\dom1\Core\Dept\FPS\Groups\KVG\College Resumes\2021\03 01' ...
    '\\dom1\Core\Dept\FPS\Groups\KVG\College Resumes\2021\03 08' ...
    '\\dom1\Core\Dept\FPS\Groups\KVG\College Resumes\2021\03 10' ...
	'\\dom1\Core\Dept\FPS\Groups\KVG\College Resumes\2021\03 22' ...
	'\\dom1\Core\Dept\FPS\Groups\KVG\College Resumes\2021\03 29'};
cdir = pwd;

keywordSearch = {'math' 'computer' 'science' 'physics' 'algorithm' 'control'};
keywordExclude = {''};

sdir = [cdir '\MnS'];
mkdir(sdir);

for ipdf = 1:length(pdfFolders)
    pdfFolder = pdfFolders{ipdf};
    clear opdf;
    
    cd(pdfFolder);
    allfiles = ls;
    count = 0;
    [r,c] = size(allfiles);
    for i = 1:r
        if ~isempty(strfind(allfiles(i,:),'.pdf')) || ~isempty(strfind(allfiles(i,:),'.docx'))
            count = count + 1;
            opdf{count} = allfiles(i,:);
        end
    end
    
    for i = 1:length(opdf)
        fullpdf = [pdfFolder '\' opdf{i}];
        
        try
            str = extractFileText(fullpdf);
        catch
            disp(['Could not read file: ' opdf{i}]);
            str = '';
        end
        
        % Search for these words we want
        scount = 0;
        lks = length(keywordSearch);
        for j = 1:length(keywordSearch)
            output  = strfind(str,keywordSearch{j});    
            if ~isempty(output)
                scount = scount + 1;
            end
        end
        
        % Search for words we do not want
        scountE = 0;
        for j = 1:length(keywordExclude)
            output  = strfind(str,keywordExclude{j});    
            if ~isempty(output)
                scountE = scountE + 1;
            end
        end
        
        if scount == lks && scountE == 0
            copyfile(fullpdf,[sdir  '\' opdf{i}]);
        end     
    end
    
    cd(cdir);
end
