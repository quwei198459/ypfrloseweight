from PIL import Image
import os
from collections import Counter
from pathlib import Path

def analyze_image(filepath):
    """分析图片的基本信息"""
    img = Image.open(filepath)
    width, height = img.size
    
    print(f"\n{'='*50}")
    print(f"文件: {os.path.basename(filepath)}")
    print(f"尺寸: {width}x{height}")
    print(f"模式: {img.mode}")
    
    # 缩小图片以加快处理
    img_small = img.resize((width//10, height//10))
    pixels = list(img_small.getdata())
    
    # 统计最常见的颜色
    if img.mode == 'RGBA':
        colors = [(p[0], p[1], p[2]) for p in pixels if len(p) >= 3]
    else:
        colors = pixels
    
    color_counts = Counter(colors)
    top_colors = color_counts.most_common(10)
    
    print(f"\n主要颜色 (前10个):")
    for i, (color, count) in enumerate(top_colors, 1):
        percentage = (count / len(colors)) * 100
        print(f"  {i}. RGB{color} - {percentage:.1f}%")
    
    # 分析图片的区域
    print(f"\n布局分析:")
    print(f"  顶部区域 (0-{height//4}px)")
    print(f"  中部区域 ({height//4}-{height*3//4}px)")
    print(f"  底部区域 ({height*3//4}-{height}px)")
    
    return img

# 分析所有登录页截图
repo_root = Path(__file__).resolve().parent
login_dir = repo_root / 'screenshots' / 'login'
files = ['01.png', '02_status.png', '03_popup.png']

for filename in files:
    filepath = login_dir / filename
    if filepath.exists():
        analyze_image(str(filepath))
