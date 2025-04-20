[🇨🇳 中文说明](readme.md)

# ocrit

**ocrit** is a macOS command-line tool that uses the built-in Vision framework to perform OCR (Optical Character Recognition). It supports both Simplified Chinese and English, and can export results in multiple formats.

![platform](https://img.shields.io/badge/platform-macOS-blue)
![license](https://img.shields.io/badge/license-MIT-green)
![language](https://img.shields.io/badge/language-Swift-orange)

## ✨ Features

- ✅ Built-in Vision-powered OCR
- ✅ Supports Simplified Chinese and English
- ✅ Exports to `.txt`, `.json`, and annotated `.jpg`
- ✅ Enhanced mode to group lines by pixel position
- ✅ Short aliases for all CLI arguments

## 🚀 Quick Start

### 1. Build

```bash
git clone https://github.com/ihugang/ocrtool.git
cd ocrtool
swift build -c release
```

### 2. Usage

```bash
.build/release/ocrtool \
  --input test.jpg \
  --txt result.txt \
  --json result.json \
  --draw marked.jpg \
  --enhanced
```

Or use short options:

```bash
.build/release/ocrtool \
  -i test.jpg \
  -t result.txt \
  -j result.json \
  -d marked.jpg \
  -e
```

## 🧩 Arguments

| Option        | Alias | Description |
|---------------|-------|-------------|
| `--input`     | `-i`  | Path to input image (required) |
| `--txt`       | `-t`  | Output text file (line-based) |
| `--json`      | `-j`  | Output JSON with text and bounding boxes |
| `--draw`      | `-d`  | Output annotated image |
| `--enhanced`  | `-e`  | Enable enhanced mode (reconstruct lines by Y position) |

## 📦 Output Examples

### Enhanced Text Output

```
Hello world from image
This is a second line
```

### JSON Format (in pixels)

```json
[
  {
    "text": "Hello",
    "boundingBox": { "x": 48, "y": 92, "width": 120, "height": 20 }
  }
]
```

### Annotated Image

> Detected regions are marked with red rectangles for visual verification.

## 👨‍💻 Author

- Hu Gang ([@ihugang](https://github.com/ihugang))
- ihugang@gmail.com

## 📝 License

MIT License
