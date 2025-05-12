# Deep Learning Analysis for qBRM Imaging of Myelin Defects

## Overview

This software automates the analysis of quantitative Birefringence Microscopy (qBRM) images using deep learning techniques to detect and quantify myelin pathology. It was developed to support large-scale, high-resolution imaging studies of myelin in post-mortem brain tissue.

The pipeline enables researchers to efficiently identify myelin defects across entire tissue sections using trained object detection models, significantly accelerating annotation and quantification tasks.

Developed by **Alexander Gray** in the **Biomedical Optics Lab**, this tool is part of a broader effort to advance label-free, high-throughput imaging for neuroscience research.

## Features

- Load and visualize qBRM datasets
- Run deep learning-based object detection models
- Support for multiple color channels and image augmentation
- Automated analysis across multiple tissue sections or samples
- Export results in standard formats for downstream analysis
- GUI developed using MATLAB App Designer for ease of use

## Requirements

- MATLAB R2021b or newer (with Deep Learning Toolbox)
- Image Processing Toolbox
- Computer Vision Toolbox (for object detection workflows)
- Pre-trained YOLOv4 model (provided separately or trained using your dataset)

## Installation

1. Clone or download this repository:
    ```
    git clone https://github.com/YOUR_USERNAME/qbrm-myelin-analysis.git
    ```

2. Open MATLAB and add the folder to your MATLAB path:
    ```matlab
    addpath(genpath('path_to_cloned_repo'));
    ```

3. Open the main app:
    ```matlab
    deep_learning_app.mlapp
    ```

## Usage

1. Launch the GUI by running:
    ```matlab
    deep_learning_app
    ```

2. Use the GUI tabs to:
    - Select your qBRM image dataset
    - Configure model input size and file structure
    - Run deep learning inference on selected samples
    - Visualize and export defect detection results

3. Optionally, save cropped ROIs and annotations for training or validation.

## File Structure

- `/app/` - MATLAB App Designer GUI
- `/models/` - Pretrained YOLOv4 model weights and configuration
- `/Functions/` - Helper functions for preprocessing, training, and analysis
- `/default_save_folder/` - Folder for saving the output for deep learning analysis

## Citation

If you use this software in your research, please cite:

> Birefringence microscopy enables rapid, label-free quantification of myelin debris following induced cortical injury _Neurophotonics_ **[Under review]**

## License

This project is for academic and research use only. Please contact the author for commercial licensing inquiries.

## Contact

For questions, issues, or collaboration inquiries, please contact:

**Alexander Gray**  
Biomedical Optics Lab  
Email: [algray@bu.edu]  
GitHub: [https://github.com/alexgray103]
