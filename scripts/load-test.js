const http = require('http')

const url = process.argv[2] || 'http://localhost:3000'
const concurrency = parseInt(process.argv[3], 10) || 10
const totalRequests = parseInt(process.argv[4], 10) || 100

const { hostname, port, pathname } = new URL(url)

let completed = 0
let success = 0
let failed = 0
const times = []

function sendRequest() {
    if (completed >= totalRequests) return

    const start = Date.now()
    const req = http.get({ hostname, port, path: pathname, timeout: 10000 }, (res) => {
        let data = ''
        res.on('data', (chunk) => (data += chunk))
        res.on('end', () => {
            const elapsed = Date.now() - start
            times.push(elapsed)
            completed++
            if (res.statusCode >= 200 && res.statusCode < 300) success++
            else failed++
            if (completed % 10 === 0 || completed === totalRequests) {
                printStats()
            }
            sendRequest()
        })
    })

    req.on('error', () => {
        const elapsed = Date.now() - start
        times.push(elapsed)
        completed++
        failed++
        sendRequest()
    })

    req.on('timeout', () => {
        req.destroy()
    })
}

function printStats() {
    const sorted = [...times].sort((a, b) => a - b)
    const avg = times.reduce((sum, t) => sum + t, 0) / times.length
    const p95 = sorted[Math.floor(sorted.length * 0.95)]
    const p99 = sorted[Math.floor(sorted.length * 0.99)]

    process.stdout.write(
        `\r${completed}/${totalRequests}  |  ` +
        `OK: ${success}  Failed: ${failed}  |  ` +
        `Avg: ${avg.toFixed(0)}ms  P95: ${p95 || 0}ms  P99: ${p99 || 0}ms` +
        '   '
    )
}

console.log(
    `Load test: ${url}  |  Concurrency: ${concurrency}  |  Requests: ${totalRequests}\n`
)

for (let i = 0; i < concurrency; i++) {
    sendRequest()
}
