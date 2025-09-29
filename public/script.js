// 全局变量
let novelData = null;
let currentChapter = 1;

// DOM元素
const coverPage = document.getElementById('coverPage');
const chaptersPage = document.getElementById('chaptersPage');
const readingPage = document.getElementById('readingPage');

const homeBtn = document.getElementById('homeBtn');
const chaptersBtn = document.getElementById('chaptersBtn');
const startReadingBtn = document.getElementById('startReadingBtn');
const backBtn = document.getElementById('backBtn');

const novelTitle = document.getElementById('novelTitle');
const novelAuthor = document.getElementById('novelAuthor');
const novelDescription = document.getElementById('novelDescription');

const chaptersList = document.getElementById('chaptersList');
const chapterTitle = document.getElementById('chapterTitle');
const chapterContent = document.getElementById('chapterContent');
const chapterInfo = document.getElementById('chapterInfo');

const prevChapterBtn = document.getElementById('prevChapterBtn');
const nextChapterBtn = document.getElementById('nextChapterBtn');
const prevChapterBtn2 = document.getElementById('prevChapterBtn2');
const nextChapterBtn2 = document.getElementById('nextChapterBtn2');

// 初始化应用
async function initApp() {
    try {
        const response = await fetch('/api/novel');
        novelData = await response.json();
        updateCoverPage();
        updateChaptersList();
    } catch (error) {
        console.error('加载小说数据失败:', error);
        showError('加载小说数据失败，请刷新页面重试');
    }
}

// 更新封面页面
function updateCoverPage() {
    if (!novelData) return;
    
    novelTitle.textContent = novelData.title;
    novelAuthor.textContent = `作者：${novelData.author}`;
    novelDescription.textContent = `简介：${novelData.description}`;
}

// 更新章节列表
function updateChaptersList() {
    if (!novelData) return;
    
    chaptersList.innerHTML = '';
    novelData.chapters.forEach(chapter => {
        const chapterItem = document.createElement('div');
        chapterItem.className = 'chapter-item';
        chapterItem.innerHTML = `
            <h3>${chapter.title}</h3>
            <p>点击开始阅读</p>
        `;
        chapterItem.addEventListener('click', () => {
            currentChapter = chapter.id;
            showReadingPage();
            loadChapter(chapter.id);
        });
        chaptersList.appendChild(chapterItem);
    });
}

// 加载章节内容
async function loadChapter(chapterId) {
    try {
        const response = await fetch(`/api/chapter/${chapterId}`);
        const chapter = await response.json();
        
        chapterTitle.textContent = chapter.title;
        chapterContent.textContent = chapter.content;
        
        const totalChapters = novelData.chapters.length;
        chapterInfo.textContent = `第${chapterId}章 / 共${totalChapters}章`;
        
        // 更新按钮状态
        prevChapterBtn.disabled = chapterId <= 1;
        nextChapterBtn.disabled = chapterId >= totalChapters;
        prevChapterBtn2.disabled = chapterId <= 1;
        nextChapterBtn2.disabled = chapterId >= totalChapters;
        
    } catch (error) {
        console.error('加载章节失败:', error);
        showError('加载章节失败，请重试');
    }
}

// 显示页面
function showCoverPage() {
    coverPage.classList.remove('hidden');
    chaptersPage.classList.add('hidden');
    readingPage.classList.add('hidden');
    homeBtn.classList.add('active');
    chaptersBtn.classList.remove('active');
}

function showChaptersPage() {
    coverPage.classList.add('hidden');
    chaptersPage.classList.remove('hidden');
    readingPage.classList.add('hidden');
    homeBtn.classList.remove('active');
    chaptersBtn.classList.add('active');
}

function showReadingPage() {
    coverPage.classList.add('hidden');
    chaptersPage.classList.add('hidden');
    readingPage.classList.remove('hidden');
    homeBtn.classList.remove('active');
    chaptersBtn.classList.remove('active');
}

// 导航到上一章
function goToPrevChapter() {
    if (currentChapter > 1) {
        currentChapter--;
        loadChapter(currentChapter);
    }
}

// 导航到下一章
function goToNextChapter() {
    if (currentChapter < novelData.chapters.length) {
        currentChapter++;
        loadChapter(currentChapter);
    }
}

// 显示错误信息
function showError(message) {
    alert(message);
}

// 事件监听器
homeBtn.addEventListener('click', showCoverPage);
chaptersBtn.addEventListener('click', showChaptersPage);
startReadingBtn.addEventListener('click', () => {
    currentChapter = 1;
    showReadingPage();
    loadChapter(currentChapter);
});
backBtn.addEventListener('click', showCoverPage);

prevChapterBtn.addEventListener('click', goToPrevChapter);
nextChapterBtn.addEventListener('click', goToNextChapter);
prevChapterBtn2.addEventListener('click', goToPrevChapter);
nextChapterBtn2.addEventListener('click', goToNextChapter);

// 键盘导航
document.addEventListener('keydown', (e) => {
    if (readingPage.classList.contains('hidden')) return;
    
    switch(e.key) {
        case 'ArrowLeft':
            e.preventDefault();
            goToPrevChapter();
            break;
        case 'ArrowRight':
            e.preventDefault();
            goToNextChapter();
            break;
        case 'Escape':
            e.preventDefault();
            showCoverPage();
            break;
    }
});

// 页面加载完成后初始化
document.addEventListener('DOMContentLoaded', initApp);
