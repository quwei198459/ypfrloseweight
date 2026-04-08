import base64
from PIL import Image
from pathlib import Path

def analyze_login_screenshots():
    """分析登录页截图的详细信息"""

    repo_root = Path(__file__).resolve().parent
    login_dir = repo_root / 'screenshots' / 'login'
    files = {
        '01.png': '登录页主界面',
        '02_status.png': '登录状态',
        '03_popup.png': '弹窗'
    }
    
    for filename, description in files.items():
        filepath = login_dir / filename
        try:
            img = Image.open(str(filepath))
            width, height = img.size
            
            # 转换为 base64 用于显示
            with open(filepath, 'rb') as f:
                base64.b64encode(f.read()).decode()
            
            print(f"\n{'='*60}")
            print(f"文件: {filename} ({description})")
            print(f"尺寸: {width}x{height}")
            print(f"模式: {img.mode}")
            
            # 分析图片的主要区域
            pixels = img.load()
            
            # 采样分析
            print(f"\n区域分析:")
            print(f"  顶部 (y=0-{height//4}): 背景色分析")
            print(f"  中部 (y={height//4}-{height*3//4}): 内容区域")
            print(f"  底部 (y={height*3//4}-{height}): 底部区域")
            
            # 保存 base64 数据用于后续处理
            print(f"\n图片已加载，可用于分析")
            
        except Exception as e:
            print(f"错误处理 {filename}: {e}")

if __name__ == '__main__':
    analyze_login_screenshots()
