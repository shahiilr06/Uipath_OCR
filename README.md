# Uipath_OCR

An offline, high-accuracy **OCR Extractor for ID Cards and Documents** built for **UiPath Studio** (Windows / VisualBasic).

## 🚀 Overview

This automation batch-processes identity documents and ID cards (such as PAN cards) placed in the `Input/` folder, performing high-speed offline optical character recognition (OCR) and structured field extraction without requiring any third-party cloud API keys or Document Understanding credits.

### Extracted Fields
- **Document Type** (e.g. `PAN-style sample`)
- **Full Name** (e.g. `SHAHIIL R`, `LOKESHWARAN`, `ARUN SAMPLE`)
- **Parent / Guardian** (e.g. `RAMESH`, `SANKAR`, `KUMAR SAMPLE`)
- **Date of Birth** (normalized to `DD/MM/YYYY`)
- **Document Number** (e.g. `ASDFT4567T`, `RTYUW9876E`, `ABCDE1234F`)
- **Issue Date** (normalized to `DD/MM/YYYY`)
- **Address** (e.g. `TT NAGAR KARAIKUDI`, `CHENNAI`, `12 Example Street...`)
- **Extraction Status** (`Success` / `Failed`)

---

## 📁 Project Structure

```text
OCR_project/
├── .objects/                 # UiPath Object Repository metadata
├── .settings/                # UiPath project settings
├── Input/                    # Place image files here (.png, .jpg, .bmp)
├── Output/                   # Extracted output files (.json & .csv)
│   ├── Extracted_Documents_Data.json
│   └── Extracted_Documents_Data.csv
├── Scripts/
│   └── ExtractOcrText.ps1    # Offline Windows Media OCR engine script
├── Main.xaml                 # Main automation workflow
├── project.json              # UiPath project configuration & dependencies
└── README.md
```

---

## 🛠️ Requirements & Setup

- **UiPath Studio** (2024+ or 2026.0+ with Windows target framework)
- **Windows 10 / 11** (provides built-in `Windows.Media.Ocr` engine)
- **Zero Cloud API Keys Required** (Runs 100% locally and offline)

---

## ▶️ How to Run & Debug

1. Clone this repository:
   ```bash
   git clone https://github.com/shahiilr06/Uipath_OCR.git
   ```
2. Open **UiPath Studio**.
3. Click **Open a Local Project** and select `project.json`.
4. Place any document or ID images inside the `Input/` folder.
5. Click **Run** (`F5`) or **Debug**.
6. View real-time extraction logs in the Studio **Output** panel.
7. Open the generated results in `Output/Extracted_Documents_Data.csv` or `Output/Extracted_Documents_Data.json`.

---

## 🛡️ Key Features

- **Date Special Character Restoration**: Repairs OCR misreads where slashes `/` are read as `1` or `l` (e.g., `06109/2005` ➔ `06/09/2005`).
- **Flexible Pattern Matching**: Handles single-letter initials, single-word names, and city-only addresses.
- **File-Lock Resiliency**: Safely catches file locks if the output CSV is open in Microsoft Excel during a run and exports to a timestamped backup file without crashing.
