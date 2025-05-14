function iou = computeIoU(predMask, trueMask)
    % predMask, trueMask: logical masks
    predMask = logical(predMask);
    trueMask = logical(trueMask);

    intersection = sum(predMask(:) & trueMask(:));
    union = sum(predMask(:) | trueMask(:));

    if union == 0
        iou = 1; % 若兩者皆為空，視為完美預測
    else
        iou = intersection / union;
    end
end
