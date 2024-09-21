import torch
from model import UNet3D
from model2 import ResUNet3D
from model3 import UNETR
from dataset import MedicalDataset
from torch.utils.data import DataLoader

import sys
sys.path.append('/home/vinti_agarwal/shashwath/try1')

# Define device
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

# Paths to the trained model checkpoints
model_paths = {
    'UNet3D': 'downloaded_weights',  # Update with the actual path
    'ResUNet3D': 'downloaded_weights',  # Update with the actual path
    'UNETR': 'downloaded_weights'  # Update with the actual path
}

# Initialize and load each model
models = []

# UNet3D model
unet3d = UNet3D(in_channels=2, out_channels=1).to(device)
unet3d.load_state_dict(torch.load(model_paths['UNet3D'], map_location=device))
unet3d.eval()  # Set to evaluation mode
models.append(unet3d)

# ResUNet3D model
resunet3d = ResUNet3D(in_channels=2, out_channels=1).to(device)
resunet3d.load_state_dict(torch.load(model_paths['ResUNet3D'], map_location=device))
resunet3d.eval()  # Set to evaluation mode
models.append(resunet3d)

# UNETR model
unetr = UNETR(img_shape=(128, 128, 128), input_dim=2, output_dim=1, embed_dim=768, patch_size=16, num_heads=12, dropout=0.1).to(device)
unetr.load_state_dict(torch.load(model_paths['UNETR'], map_location=device))
unetr.eval()  # Set to evaluation mode
models.append(unetr)

# Function to ensemble predictions
def ensemble_predictions(models, image):
    # Get predictions from each model
    predictions = [torch.sigmoid(model(image)).detach() for model in models]
    
    # Stack predictions along a new dimension and take the mean
    ensemble_prediction = torch.mean(torch.stack(predictions), dim=0)

    return ensemble_prediction

# Load the dataset
images_dir = '/home/vinti_agarwal/shashwath/imagesTr'
labels_dir = '/home/vinti_agarwal/shashwath/labelsTr'
dataset = MedicalDataset(images_dir=images_dir, labels_dir=labels_dir)
data_loader = DataLoader(dataset, batch_size=1, shuffle=False)

# Loop through the dataset to generate ensembled predictions
for images, _ in data_loader:
    images = images.to(device)

    # Get the ensembled prediction
    ensembled_output = ensemble_predictions(models, images)

    # Threshold the output to get a binary mask (if needed)
    binary_mask = (ensembled_output > 0.5).float()

    # Further processing of the binary_mask (e.g., saving, evaluating)
    print("Processed an image with ensemble prediction.")
