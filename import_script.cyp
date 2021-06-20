//SOURCE: https://api.pushshift.io/reddit/search/submission/?subreddit=lightbulb&sort=asc&sort_type=created_utc&after=1308773605&size=999

WITH "https://firebasestorage.googleapis.com/v0/b/nean-dev.appspot.com/o/data.json?alt=media&token=ab09d7eb-3f9d-4390-9262-a2b1b214a865" AS url
CALL apoc.load.json(url) YIELD value
UNWIND value.data AS data

WITH collect({data: data}) as xDate, count(data) as count

FOREACH (i IN RANGE(0, count - 1) |

    MERGE (user:User { username: xDate[i].data.author })
    SET user.id = i + 2
    SET user.uId = 'test-uid-' + toString(i + 2)
    SET user.email = xDate[i].data.author + '@nean.com'
    SET user.password = '7ff492b1d59a3851be7fb7a57fd125ebe801b691f524bc79ff9d96b2ad170654'
    SET user.passwordSalt = '8fb3827e049cb97032f3d1d5054d205d'
    SET user.dateCreated = timestamp()
    SET user.isVerified = false
    SET user.views = 0
    SET user.bio = ''
    SET user.avatarUrl = ''
    SET user.emailCode = ''
    SET user.emailVerified = false

    MERGE (user)-[:IS]->(user)

    CREATE (user)-[:HAS_ITEM]->(item:Item { id: i + 1, uId: 'test-uid-' + toString(i + 1), title: xDate[i].data.title, description: xDate[i].data.selftext, dateCreated: xDate[i].data.created_utc * 1000 })

)

RETURN count




// Create 50 000 users to test DB
OPTIONAL MATCH (nextUser:User)
WITH nextUser, CASE WHEN nextUser IS NULL THEN 1 ELSE nextUser.id + 1 END as nextId
ORDER BY nextUser.id DESC
LIMIT 1

FOREACH (i IN RANGE(1, 50000) |

    CREATE (user:User { username: 'username' + (nextId + i) })
    SET user.id = nextId + i
    SET user.uId = '1-2-3-4-5-' + (nextId + i)
    SET user.email = (nextId + i) + '@nean.com'
    SET user.password = '7ff492b1d59a3851be7fb7a57fd125ebe801b691f524bc79ff9d96b2ad170654'
    SET user.passwordSalt = '8fb3827e049cb97032f3d1d5054d205d'
    SET user.dateCreated = timestamp()
    SET user.isVerified = false
    SET user.views = 0
    SET user.bio = ''
    SET user.avatarUrl = ''
    SET user.emailCode = ''
    SET user.emailVerified = false

    CREATE (user)-[:IS]->(user)

)