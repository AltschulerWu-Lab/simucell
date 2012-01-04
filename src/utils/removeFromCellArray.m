function newCellArray = removeFromCellArray(cellArray,row)
  if length(cellArray)==1
    newCellArray=cell(0);
    return;
  end
  newCellArray=cell(1,length(cellArray)-1);
  j=1;
  for i=1:length(cellArray)
    if(i~=row)
      newCellArray{j}=cellArray{i};
      j=j+1;
    end
  end
end

