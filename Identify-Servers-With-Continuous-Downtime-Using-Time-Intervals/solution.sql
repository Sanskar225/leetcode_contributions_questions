WITH down_logs AS (
    SELECT
        server_id,
        checked_at,
        -- Determine whether this row starts a new consecutive group
        CASE
            WHEN LAG(checked_at) OVER (
                PARTITION BY server_id
                ORDER BY checked_at
            ) = checked_at - INTERVAL 5 MINUTE
            THEN 0  -- Continue existing group
            ELSE 1  -- Start a new group
        END AS is_new_group
    FROM server_logs
    WHERE status = 'down'
),
grouped AS (
    SELECT
        server_id,
        checked_at,
        -- Generate a unique group ID using a running sum
        SUM(is_new_group) OVER (
            PARTITION BY server_id
            ORDER BY checked_at
        ) AS grp
    FROM down_logs
)
SELECT
    server_id,
    MIN(checked_at) AS downtime_start,
    MAX(checked_at) AS downtime_end,
    TIMESTAMPDIFF(
        MINUTE,
        MIN(checked_at),
        MAX(checked_at)
    ) AS duration_minutes
FROM grouped
GROUP BY server_id, grp
HAVING COUNT(*) >= 6   -- At least 6 consecutive checks
ORDER BY server_id, downtime_start;