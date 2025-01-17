-- 데이터베이스 생성
CREATE DATABASE instagram_clone
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

-- 게시물 테이블
CREATE TABLE posts
(
    id         BIGINT AUTO_INCREMENT PRIMARY KEY,
    content    TEXT,
    writer     VARCHAR(100) NOT NULL,
    view_count INT       DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM posts;
SELECT * FROM post_images;

DELETE FROM posts;

SELECT  
	P.*
    , I.*
FROM posts P
JOIN post_images I
ON P.id = I.post_id
;



-- 게시물 이미지 테이블
CREATE TABLE post_images
(
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    post_id     BIGINT       NOT NULL,
    image_url   VARCHAR(255) NOT NULL,
    image_order INT          NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE
);

-- ==============
-- 해시태그 테이블
CREATE TABLE hashtags
(
    id         BIGINT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 게시물 해시태그 연결 테이블
CREATE TABLE post_hashtags
(
    id         BIGINT AUTO_INCREMENT PRIMARY KEY,
    post_id    BIGINT NOT NULL,
    hashtag_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE,
    FOREIGN KEY (hashtag_id) REFERENCES hashtags (id) ON DELETE CASCADE,
    UNIQUE KEY unique_post_hashtag (post_id, hashtag_id)
)
;



SELECT * FROM posts;
SELECT * FROM hashtags;
SELECT * FROM post_hashtags;

-- 특정 단어로 시작하는 해시태그 검색하기(A)
SELECT
	h.name
FROM hashtags h
WHERE name LIKE '나%'
LIMIT 5
;

-- 각 해시태그들이 달린 게시물 수 확인하기(B)
SELECT
	hashtag_id
    , COUNT(post_id)
FROM post_hashtags
GROUP BY hashtag_id
ORDER BY hashtag_id
;

-- (A) + (B)
SELECT
	 p.name
	, COUNT(ph.post_id) feed_count
FROM post_hashtags ph
RIGHT OUTER JOIN hashtags p
ON ph.hashtag_id = p.id
WHERE p.name LIKE '나%' -- "나_" 로 시작하는 단어찾기
GROUP BY p.name
ORDER BY feed_count DESC
LIMIT 3
;

-- 인덱스 추가
CREATE INDEX idx_hashtag_name ON hashtags (name);
CREATE INDEX idx_post_hashtags_post_id ON post_hashtags (post_id);
CREATE INDEX idx_post_hashtags_hashtag_id ON post_hashtags (hashtag_id);