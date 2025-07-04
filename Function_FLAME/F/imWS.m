function imWS(name,file)
name = double(name);
name = name./max(max(max(name)));
imwrite (name(:,:,1),[file,'.tif']);
for i = 2:size(name,3) 
    imwrite (name(:,:,i),[file,'.tif'],'WriteMode','append');
end