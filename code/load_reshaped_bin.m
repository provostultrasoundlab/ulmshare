function [data, header] = load_reshaped_bin(filepath)
    fileID = fopen(filepath, 'r');
    header = fread(fileID, 3, 'int32');  % Lire le header
    data = fread(fileID, Inf, 'int16=>int16');  % Lire les données
    fclose(fileID);
    data = reshape(data, header(1), header(2), header(3));  % Reshape
end 
