function generate_doc(dirName)

  %fileList=getAllFiles(['plugins' filesep]);
  fullDirName=[pwd filesep dirName];
  fileList=getAllFiles(fullDirName);
  mFileListIndex=cellfun(@(x)regexp(x,'\S*.m$'),fileList,...
    'UniformOutput',false);
  mFileList=fileList(cellfun(@(y)~isempty(y),mFileListIndex));
  mFileList = strrep(mFileList, fullDirName, '');%Remove dir path
  
  finalHTMLDoc=... 
    ['<html>' char(13)...
    ' <head>' char(13)...
    '    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">' char(13)...
    '    <link rel="stylesheet" href="css/documentation.css">' char(13)...
    '    <title>SimuCell Plugins Help</title>' char(13)...
    ' </head>' char(13)...
    ' <body>' char(13)...
    '<div id="sidebar" class="interface">' char(13)];
  
  
  %FIRST PATH: Build TOC
  previousPluginType='';
  previousPluginSubType='';
  for i=1:length(mFileList)
    fileName=mFileList{i};
    %fileName='cell_artifacts/Cell_Staining_Artifacts.m';
    dirPositions=strfind(fileName,filesep);
    lastDirPos=dirPositions(length(dirPositions));
    pluginName=fileName(lastDirPos+1:end);
    if(length(dirPositions)==2)
      pluginType=fileName(1:dirPositions(1)-1);
      pluginSubType=fileName(dirPositions(1)+1:lastDirPos-1);
    else      
      pluginType=fileName(1:lastDirPos-1);
      pluginSubType=[];
    end    
    if(~strcmp(previousPluginType,pluginType))
      if(~strcmp('',pluginType))
        finalHTMLDoc=[finalHTMLDoc char(13) '</ul>'];
      end
      finalHTMLDoc=[finalHTMLDoc char(13) '<a class="toc_title" href="#' pluginType '">'];
      finalHTMLDoc=[finalHTMLDoc char(13) regexprep(pluginType,'_',' ')];
      finalHTMLDoc=[finalHTMLDoc char(13) '</a>'];
      finalHTMLDoc=[finalHTMLDoc char(13) '<ul class="toc_section">'];
      previousPluginType=pluginType;
    end
    finalHTMLDoc=[finalHTMLDoc char(13) '<li>– <a href="#' pluginType '-' pluginName(1:end-2) '">' pluginName(1:end-2) '</a></li>'];
  end  
  finalHTMLDoc=[finalHTMLDoc char(13) '</div>'];
  finalHTMLDoc=[finalHTMLDoc char(13) '<div class="container">'];
    
  previousPluginType='';
  previousPluginSubType='';
  for i=1:length(mFileList)
    fileName=mFileList{i};
    dirPositions=strfind(fileName,filesep);
    lastDirPos=dirPositions(length(dirPositions));
    pluginName=fileName(lastDirPos+1:end);
    if(length(dirPositions)==2)
      pluginType=fileName(1:dirPositions(1)-1);
      pluginSubType=fileName(dirPositions(1)+1:lastDirPos-1);
    else      
      pluginType=fileName(1:lastDirPos-1);
      pluginSubType=[];
    end
    disp('');
    
    htmlstr = help2html(pluginName(1:end-2),'','-doc');
    beginDoc=strfind(htmlstr,'<div class="title">');
    endDoc=strfind(htmlstr,'<!--after help -->');
    htmlstr=htmlstr(beginDoc:endDoc-1);
    htmlstr=strrep(htmlstr, 'Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab', '');
    
    if(~strcmp(previousPluginType,pluginType))
      htmlstr=['<div class="secTitle" id="' pluginType '">' regexprep(pluginType,'_',' ') '</div>' char(13) htmlstr];
      previousPluginType=pluginType;
    end
    
    
    if(~isempty(htmlstr))    
      htmlstr=strrep(htmlstr, '<pre>', '');
      htmlstr=strrep(htmlstr, '</pre>', '');
      htmlstr=strrep(htmlstr, 'Usage:', ['Usage:' char(13) '<pre>']);
      htmlstr=[htmlstr(1:end-10) '</pre>' char(13) '</div>'];
      
      htmlstr = regexprep(htmlstr, '<a[^>]*>', '<span class=property>');
      htmlstr = regexprep(htmlstr, '</a>', '</span>');
    end
    htmlstr=[char(13) '<div id="' pluginType '-' pluginName(1:end-2) '">' char(13) htmlstr char(13) '</div>'];
    finalHTMLDoc=[finalHTMLDoc htmlstr];
    disp('');
    
    
  end
  
  finalHTMLDoc=[finalHTMLDoc char(13) '</div>'];
  finalHTMLDoc=[finalHTMLDoc char(13)...
    '   <body>' char(13)...
    '<html>'];  
  %fid = fopen(['/tmp/' pluginName(1:end-2) '2.html'],'w');
  fid = fopen(['..' filesep 'documentation' filesep 'HTML' filesep dirName '_API.html'],'w');
  fprintf(fid,'%s',finalHTMLDoc);
  fclose(fid);

  function fileList = getAllFiles(dirName)

    dirData = dir(dirName);      % Get the data for the current directory
    dirIndex = [dirData.isdir];  % Find the index for directories
    fileList = {dirData(~dirIndex).name}';  % Get a list of the files
    if ~isempty(fileList)
      fileList = cellfun(@(x) fullfile(dirName,x),...  % Prepend path to files
                         fileList,'UniformOutput',false);
    end
    subDirs = {dirData(dirIndex).name};  % Get a list of the subdirectories
    validIndex = ~ismember(subDirs,{'.','..'});  % Find index of subdirectories
                                                 %   that are not '.' or '..'
    for iDir = find(validIndex)                  % Loop over valid subdirectories
      nextDir = fullfile(dirName,subDirs{iDir});    % Get the subdirectory path
      fileList = [fileList; getAllFiles(nextDir)];  % Recursively call getAllFiles
    end
  end

end
