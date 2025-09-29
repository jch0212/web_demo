const express = require('express');
const cors = require('cors');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = process.env.PORT || 3000;

// 中间件
app.use(cors());
app.use(express.json());
app.use(express.static('public'));

// 小说基本信息
const novelInfo = {
  title: "焚途狂歌",
  author: "江辰皓",
  description: "弱小的话，就积蓄力量。强大了，就守护一切。"
};

// 读取章节数据
function loadChapters() {
  const chaptersDir = path.join(__dirname, 'chapters');
  const chapters = [];
  
  try {
    if (!fs.existsSync(chaptersDir)) {
      fs.mkdirSync(chaptersDir, { recursive: true });
      return chapters;
    }
    
    const files = fs.readdirSync(chaptersDir);
    const txtFiles = files.filter(file => file.endsWith('.txt'));
    
    txtFiles.forEach((file) => {
      const filePath = path.join(chaptersDir, file);
      const content = fs.readFileSync(filePath, 'utf8');
      const chapterName = path.basename(file, '.txt');
      
      // 提取文件名中的数字
      const numberMatch = chapterName.match(/\d+/);
      const chapterNumber = numberMatch ? parseInt(numberMatch[0]) : 0;
      
      chapters.push({
        id: chapterNumber,
        title: chapterName,
        content: content,
        fileName: file
      });
    });
    
    // 按文件名中的数字排序
    chapters.sort((a, b) => a.id - b.id);
    
    // 重新分配连续的ID
    chapters.forEach((chapter, index) => {
      chapter.id = index + 1;
    });
    
  } catch (error) {
    console.error('读取章节文件失败:', error);
  }
  
  return chapters;
}

// 获取小说数据
function getNovelData() {
  const chapters = loadChapters();
  return {
    ...novelInfo,
    chapters: chapters
  };
}

// API路由
app.get('/api/novel', (req, res) => {
  const novelData = getNovelData();
  res.json(novelData);
});

app.get('/api/chapter/:id', (req, res) => {
  const chapterId = parseInt(req.params.id);
  const novelData = getNovelData();
  const chapter = novelData.chapters.find(ch => ch.id === chapterId);
  
  if (chapter) {
    res.json(chapter);
  } else {
    res.status(404).json({ error: '章节未找到' });
  }
});

// 主页路由
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`服务器运行在端口 ${PORT}`);
});
