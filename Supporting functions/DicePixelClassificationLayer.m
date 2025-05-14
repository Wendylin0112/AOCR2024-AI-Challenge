classdef DicePixelClassificationLayer < nnet.layer.ClassificationLayer
    % 自訂 Dice loss 的分類層
    methods
        function layer = DicePixelClassificationLayer(name)
            % 建構子
            layer.Name = name;
            layer.Description = 'Dice loss layer for binary segmentation';
        end

        function loss = forwardLoss(layer, Y, T)
            % Y: 預測 [H W C N]，T: 標註 [H W C N]
            % 只取前景類別 (類別 2，因為類別 1 是背景)
            Y = squeeze(Y(:,:,2,:));  % 預測 foreground 機率
            T = squeeze(T(:,:,2,:));  % Ground truth one-hot 的前景

            Y = double(Y);
            T = double(T);

            intersection = sum(Y(:) .* T(:));
            union = sum(Y(:)) + sum(T(:));
            smooth = 1e-6;

            diceCoef = (2 * intersection + smooth) / (union + smooth);
            loss = single(1 - diceCoef);
        end
    end
end
