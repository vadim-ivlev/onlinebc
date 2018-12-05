INSERT INTO media (post_id, uri, source)
SELECT 
    id post_id,
    split_part(img,'|',1) AS uri,
    split_part(img,'|',2) AS source
FROM 
    public.post
WHERE 
    img <> 'none_img'
;


