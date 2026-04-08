/** 将本地临时路径读为纯 base64（不含 data URL 前缀），供识图接口使用 */
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
        fail: (err) => {
          reject(new Error(err.errMsg || '读取图片失败'))
        },
      })
    } catch (e) {
      reject(e instanceof Error ? e : new Error('读取图片失败'))
    }
  })
}
