■初期化パラメータ(nls_length_semantics)
SELECT NAME,VALUE FROM V$SYSTEM_PARAMETER WHERE NAME = 'nls_length_semantics'

■テーブル情報
SELECT 
  A.TABLE_NAME,
  A.COLUMN_ID,
  A.COLUMN_NAME,
  A.DATA_TYPE,
  A.DATA_LENGTH,
  B.COMMENTS,
  CASE WHEN C.CONSTRAINT_TYPE='P' THEN 1 ELSE 0 END AS PRIMARY_KEY
FROM 
  USER_TAB_COLUMNS A
  INNER JOIN USER_COL_COMMENTS B ON (A.TABLE_NAME=B.TABLE_NAME AND A.COLUMN_NAME=B.COLUMN_NAME)
  LEFT JOIN (
    SELECT 
      X.TABLE_NAME,
      Y.COLUMN_NAME,
      X.CONSTRAINT_TYPE
    FROM
      USER_CONSTRAINTS X 
      INNER JOIN USER_CONS_COLUMNS Y
        ON (X.TABLE_NAME=Y.TABLE_NAME AND X.CONSTRAINT_NAME=Y.CONSTRAINT_NAME)
    WHERE
      X.CONSTRAINT_TYPE='P'
  ) C ON (A.TABLE_NAME=C.TABLE_NAME AND A.COLUMN_NAME=C.COLUMN_NAME)
WHERE
  A.TABLE_NAME='CTANKEN' AND
  A.COLUMN_NAME NOT IN ('INSDATE','INSUSRID','INSPGID','UPDUSRID','UPDPGID','REVISION')
ORDER BY
  A.TABLE_NAME,
  A.COLUMN_ID
