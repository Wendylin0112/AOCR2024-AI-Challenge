# AOCR2024-AI-Challenge

# Acute Appendicitis Classification using U-Net Framework

## Project at a glance

This repository documents an **academic medical-image analysis project** exploring acute appendicitis identification from CT scans using **2D U-Net and 3D nnU-Net**. The experiments investigate image preprocessing, Dice loss, post-processing thresholds, and computational limitations.

- **Task:** CT-based segmentation and scan-level identification of acute appendicitis
- **Methods:** 2D U-Net, 3D nnU-Net, normalization, augmentation, threshold-based post-processing
- **Reported outcome:** A peak F1-score of **0.875** for the 2D U-Net experiments; see the detailed results below for the evaluation context and variation
- **Artifacts:** [Written report](./基於U-Net的急性闌尾炎分類任務_書面報告.pdf) · [Project poster](./醫學影像project壁報影印版本.pdf)

> **Scope:** This is a course/challenge-based experimental project, not a clinically validated diagnostic system.

---

本專案旨在透過 **深度學習模型 (2D U-Net 與 nnU-Net)** 進行 **急性闌尾炎 (Acute Appendicitis)** CT 影像的自動化分類與分割，以期提升臨床診斷的效率與準確性。  

## 📑 Table of Contents
- [Background](https://github.com/Wendylin0112/AOCR2024-AI-Challenge/blob/main/README.md#-background)
- [Dataset](https://github.com/Wendylin0112/AOCR2024-AI-Challenge/blob/main/README.md#-dataset)
- [Model Design](https://github.com/Wendylin0112/AOCR2024-AI-Challenge/blob/main/README.md#-model-design)
- [Methods](https://github.com/Wendylin0112/AOCR2024-AI-Challenge/blob/main/README.md#%EF%B8%8F-methods)
- [Results](https://github.com/Wendylin0112/AOCR2024-AI-Challenge/blob/main/README.md#-results)
- [Conclusion & Future Work](https://github.com/Wendylin0112/AOCR2024-AI-Challenge/blob/main/README.md#-conclusion--future-work)
- [References](https://github.com/Wendylin0112/AOCR2024-AI-Challenge/blob/main/README.md#-references)

---

## 📌 Background
急性闌尾炎是常見的急腹症，若未即時診斷，可能引發 **腹膜炎、敗血症**，甚至休克死亡。  
目前診斷多依賴醫師判讀 **CT/MRI 影像**，但具有以下問題：
- 判讀具主觀性，症狀表現不明顯
- 與其他疾病重疊，容易誤診或延誤治療  

👉 本研究透過 **深度學習** 自動化模型，期望降低誤診率並加快診斷速度。

---

## 📂 Dataset
- 來源：Kaggle **AOCR 2024 醫學影像競賽**，由亞東醫院提供  
- 內容：
  - **300 組** 含標註的腹部 CT 影像 (NIfTI 格式)
  - **20 組** 無標註測試影像
- 切片厚度：5 mm  
- 標註內容：闌尾炎 segmentation mask

---

## 🏗 Model Design

### 🔹 U-Net
- 專為醫學影像設計的 **語意分割架構**  
- 採用 **Encoder-Decoder** 結構  
- **跳接 (skip connections)** 保留細節資訊  
- 適合小型資料集的精準像素級分割

### 🔹 nnU-Net
- **no-new-Net**，自動調整 U-Net 架構  
- 會依任務自動設置：
  - 前處理
  - 網路架構
  - 訓練參數  
- 預設需長時間訓練 (1000 epochs)，本研究因資源限制僅訓練 **30 epochs**

---

## ⚙️ Methods
### Data Preprocessing
- **Normalization**：`img / 4095`  
  - 保留原始 CT 強度分布  
  - 優於 `mat2gray` 的線性拉伸
- **Augmentation**：影像翻轉、旋轉  
- **Post-processing**：
  - 機率閾值 > 0.77
  - 面積閾值：取訓練集中 **有遮罩面積的第 9 百分位數** 過濾掉過小偽陽性區域

### Loss Function
- 比較 **MATLAB 內建 loss** 與 **Dice Loss**
- Dice Loss 表現顯著提升 segmentation 效果

### Evaluation Metric
- **F1-score** (scan-level 與 slice-level)

---

## 📊 Results
### U-Net (2D, 手動調參)
- **F1-score**：最高可達 0.875  
- 表現差異大 (部分低至 0.25)  
- **Scan-level**：
  - 正確辨識 10 位病人
  - 誤判 7 位健康病人  
  - 平均 F1 ≈ **0.74**

### nnU-Net (3D, 自動化調參)
- **F1-score**：0.1 ~ 0.3  
- FP 數量偏高  
- **Scan-level**：
  - 正確辨識 10 位病人
  - 誤判 10 位健康病人  
  - 平均 F1 ≈ **0.66**

---

## ✅ Conclusion & Future Work
- **結論**
  - U-Net (手動調參) 在小型醫療影像資料集上表現較佳，具 **效率與彈性**
  - nnU-Net 雖有自動化優勢，但需更多訓練資源與更長時間，短期內未展現潛力

- **未來工作**
  - 統一資料處理流程，確保公平比較
  - 提升 nnU-Net 訓練資源 (完整 1000 epochs)
  - 擴充更大規模資料集，提升泛化能力

---

## 📖 References
1. Ronneberger, O., Fischer, P., & Brox, T. (2015). **U-Net: Convolutional Networks for Biomedical Image Segmentation**. *MICCAI 2015*. [DOI:10.1007/978-3-319-24574-4_28](https://doi.org/10.1007/978-3-319-24574-4_28)  
2. Isensee, F., Jaeger, P.F., Kohl, S.A.A., et al. (2021). **nnU-Net: a self-configuring method for deep learning-based biomedical image segmentation**. *Nature Methods, 18*, 203–211. [DOI:10.1038/s41592-020-01008-z](https://doi.org/10.1038/s41592-020-01008-z)  

---

## 🖼 Poster
> 詳細展示請參見 [專案壁報](./醫學影像project壁報影印版本.pdf) 與 [書面報告](./基於U-Net的急性闌尾炎分類任務_書面報告.pdf)。

