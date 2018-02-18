function hdr=read_nii_hdr(name)
%function hdr=read_nii_hdr(name)

% maek sure filename is in the right format
suffix = name(end-2:end);
if strcmp(suffix,'.gz')
    eval(['!gunzip ' name]);
    name = name(1:end-3);
elseif strcmp(suffix,'nii')
    name = name;
else
    name = sprintf('%s.nii',name);
end

% first detect which endian file we're opening
[pFile,messg] = fopen(name, 'r','native');
if pFile == -1
    fprintf('Error opening header file: %s',name);
    return;
end

tmp = fread(pFile,1,'int32');

if strcmp(computer,'GLNX86') || \
        strcmp(computer , 'PCWIN') || \
        strcmp(computer,'GLNXA64') || \
        strcmp(computer,'MACI')

    if tmp==348
        endian='ieee-le';
    else
        endian='ieee-be';
    end

else
    if tmp==348
        endian='ieee-be';
    else
        endian='ieee-le';
    end

end
fclose(pFile);
% Now Read in Headerfile into the hdrstruct
[pFile,messg] = fopen(name, 'r', endian);
if pFile == -1
    msgbox(sprintf('Error opening header file: %s',name));
    return;
end


hdr = struct (...
    'sizeof_hdr'    , fread(pFile, 1,'int32')',...	% should be 348!
    'data_type'     , (fread(pFile,10,'*char')'),...
    'db_name'       , (fread(pFile,18,'*char')'),...
    'extents'       , fread(pFile, 1,'int32')', ...
    'session_error' , fread(pFile, 1,'int16')', ...
    'regular'       , fread(pFile, 1,'*char')', ...
    'dim_info'      , fread(pFile, 1,'*char')', ...
    'dim'        , fread(pFile,8,'int16')', ...
    'intent_p1'  , fread(pFile,1,'float32')', ...
    'intent_p2'  , fread(pFile,1,'float32')', ...
    'intent_p3'  , fread(pFile,1,'float32')', ...
    'intent_code' , fread(pFile,1,'int16')', ...
    'datatype'   , fread(pFile,1,'int16')', ...
    'bitpix'     , fread(pFile,1,'int16')', ...
    'slice_start' , fread(pFile,1,'int16')', ...
    'pixdim'     , fread(pFile,8,'float32')', ...
    'vox_offset' , fread(pFile,1,'float32')', ...
    'scl_slope'  , fread(pFile,1,'float32')', ...
    'scl_inter'  , fread(pFile,1,'float32')', ...
    'slice_end'  , fread(pFile,1,'int16')', ...
    'slice_code' , fread(pFile,1,'*char')', ...
    'xyzt_units' , fread(pFile,1,'*char')', ...
    'cal_max'    , fread(pFile,1,'float32')', ...
    'cal_min'    , fread(pFile,1,'float32')', ...
    'slice_duration' , fread(pFile,1,'float32')', ...
    'toffset'    , fread(pFile,1,'float32')', ...
    'glmax'      , fread(pFile,1,'int32')', ...
    'glmin'      , fread(pFile,1,'int32')', ...
    'descrip'     , (fread(pFile,80,'*char')'), ...
    'aux_file'    , (fread(pFile,24,'*char')'), ...
    'qform_code'  , fread(pFile,1,'int16')', ...
    'sform_code'  , fread(pFile,1,'int16')', ...
    'quatern_b'   , fread(pFile,1,'float32')', ...
    'quatern_c'   , fread(pFile,1,'float32')', ...
    'quatern_d'   , fread(pFile,1,'float32')', ...
    'qoffset_x'   , fread(pFile,1,'float32')', ...
    'qoffset_y'   , fread(pFile,1,'float32')', ...
    'qoffset_z'   , fread(pFile,1,'float32')', ...
    'srow_x'      , fread(pFile,4,'float32')', ...
    'srow_y'      , fread(pFile,4,'float32')', ...
    'srow_z'      , fread(pFile,4,'float32')', ...
    'intent_name' , (fread(pFile,16,'*char')'), ...
    'magic'       , (fread(pFile,4,'*char')'), ...
    'originator'  , fread(pFile, 5,'int16'),...
    'esize'       , 0, ...
    'ecode'       , 0, ...
    'edata'       , '' ...
    );
% this part is intended to read the extension data information at the end of the
% nifti header and before the image proper
%extendcode = fread(pFile,4,'char');
%if extendcode(1)~=0
%    hdr.esize = hdr.vox_offset-352;
%    hdr.edata = fread(pFile, hdr.esize, 'char');
%end

fclose(pFile);


return

