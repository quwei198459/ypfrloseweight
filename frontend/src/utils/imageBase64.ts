/** 读取本地临时文件为纯 base64（不含 data: 前缀），供识图等接口使用 */
export function readLocalFileAsBase64(filePath: string): Promise<string> {
  return new Promise((resolve, reject) => {
    try {
      const fs = uni.getFileSystemManager()
      fs.readFile({
        filePath,
        encoding: 'base64',
        success: (res) => {
          const data = res.data
          resolve(typeof data === 'string' ? data : '')
        },
        fail: (err) => reject(new Error(err.errMsg || '读取图片失败')),
      })
    } catch (e) {
      reject(e instanceof Error ? e : new Error('读取图片失败'))
    }
  })
}

/** 尽量压缩后再读 base64，失败则回退原路径 */
export async function compressAndReadBase64(filePath: string): Promise<string> {
  const path = await new Promise<string>((resolve) => {
    uni.compressImage({
      src: filePath,
      quality: 76,
      success: (r) => resolve(r.tempFilePath || filePath),
      fail: () => resolve(filePath),
    })
  })
  const b64 = await readLocalFileAsBase64(path)
  if (!b64) throw new Error('图片数据为空')
  return b64
}
