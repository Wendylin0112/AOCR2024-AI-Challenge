function launchViewer(ImgData, MaskData, imgIndex)
    % 取出影像與標註
    img = double(ImgData{imgIndex});
    mask = double(MaskData{imgIndex});
    [~, ~, totalSlices] = size(img);

    % 建立圖形視窗
    f = figure('Name', sprintf('Volume Viewer - Case %d', imgIndex), 'NumberTitle', 'off');

    % 初始切片
    slice_idx = round(totalSlices / 2);
    img_slice = img(:, :, slice_idx);
    mask_slice = mask(:, :, slice_idx);

    hImage = imshow(mat2gray(img_slice)); hold on;
    hOverlay = imshow(label2rgb(uint8(mask_slice), 'jet', 'k', 'shuffle'));
    set(hOverlay, 'AlphaData', 0.4 * (mask_slice > 0));
    title(sprintf('Case %d - Slice %d/%d', imgIndex, slice_idx, totalSlices));

    % 滑桿 UI
    uicontrol('Style', 'slider',...
        'Min', 1, 'Max', totalSlices, 'Value', slice_idx,...
        'Units', 'normalized', 'Position', [0.25 0.02 0.5 0.05],...
        'SliderStep', [1/(totalSlices-1), 10/(totalSlices-1)],...
        'Callback', @updateSlice);

    % 巢狀函數：更新切片
    function updateSlice(src, ~)
        idx = round(get(src, 'Value'));
        img_slice = img(:, :, idx);
        mask_slice = mask(:, :, idx);
        set(hImage, 'CData', mat2gray(img_slice));
        redMask = cat(3, ones(size(mask_slice)), zeros(size(mask_slice)), zeros(size(mask_slice)));
set(hOverlay, 'CData', redMask);
        set(hOverlay, 'AlphaData', 0.4 * (mask_slice > 0));
        title(sprintf('Case %d - Slice %d/%d', imgIndex, idx, totalSlices));
    end
end