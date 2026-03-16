import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "fileInput", "previewImg", "placeholder", "submitBtn",
    "loader", "loaderCanvas", "loaderStage", "loaderSubLabel", "loaderBar"
  ]

  pick() {
    this.fileInputTarget.click()
  }

  showPreview() {
    const file = this.fileInputTarget.files[0]
    if (!file) return
    this.previewImgTarget.src = URL.createObjectURL(file)
    this.previewImgTarget.style.display = "block"
    this.placeholderTarget.style.display = "none"
    this.submitBtnTarget.disabled = false
  }

  submitWithLoader(event) {
    event.preventDefault()
    this.loaderTarget.style.display = "flex"
    this._startCanvasAnimation()
    this._startProgressBar()

    const form = event.target
    const data = new FormData(form)

    fetch(form.action, { method: "POST", body: data })
      .then(res => res.redirected ? res.url : Promise.reject("no redirect"))
      .then(url => {
        this._fillProgressBar(() => { window.location.href = url })
      })
      .catch(() => {
        this._fillProgressBar(() => { form.submit() })
      })
  }

  // ── Progress bar ──────────────────────────────────────────

  _startProgressBar() {
    this._pct = 0
    this._barInterval = setInterval(() => {
      // Deceleration: step shrinks as we approach 82%
      const step = 0.12 * (1 - this._pct / 100)
      this._pct = Math.min(this._pct + step, 82)
      this.loaderBarTarget.style.width = this._pct + "%"
    }, 300)
  }

  _fillProgressBar(callback) {
    clearInterval(this._barInterval)
    this.loaderBarTarget.style.width = "100%"
    setTimeout(callback, 650)
  }

  // ── Pixel art canvas animation ────────────────────────────

  _startCanvasAnimation() {
    const canvas = this.loaderCanvasTarget
    const ctx    = canvas.getContext("2d")
    const stage  = this.loaderStageTarget
    const sublbl = this.loaderSubLabelTarget
    const S = 5

    // Inject floating ? marks
    const QM_COLORS = ["#f48fb1","#ce93d8","#80cbc4","#B1F542","#ffb3c1","#b3e5fc"]
    const QM_SIZES  = [7, 8, 9, 10, 7]
    for (let i = 0; i < 10; i++) {
      const el = document.createElement("div")
      el.className = "kawaii-qm"
      el.textContent = "?"
      const side = Math.floor(Math.random() * 4)
      let left, top
      if (side === 0)      { left = Math.random() * 160; top = -18 }
      else if (side === 1) { left = 162;                 top = Math.random() * 160 }
      else if (side === 2) { left = Math.random() * 160; top = 162 }
      else                 { left = -18;                 top = Math.random() * 160 }
      el.style.left             = left + "px"
      el.style.top              = top + "px"
      el.style.fontSize         = QM_SIZES[i % QM_SIZES.length] + "px"
      el.style.color            = QM_COLORS[i % QM_COLORS.length]
      el.style.animationDuration = (1.8 + Math.random() * 2.4) + "s"
      el.style.animationDelay   = (Math.random() * 3) + "s"
      stage.appendChild(el)
    }

    // ── Pixel data ──────────────────────────────────────────
    const MONSTERA_RAW = [
      {x:0,y:5,c:"#65CB2A"},{x:0,y:6,c:"#BAE75A"},{x:0,y:10,c:"#89BC3F"},{x:0,y:11,c:"#4A9E32"},
      {x:1,y:5,c:"#99CF4D"},{x:1,y:9,c:"#33A736"},{x:1,y:10,c:"#A9E83E"},{x:1,y:11,c:"#65CD29"},{x:1,y:12,c:"#ABED3E"},
      {x:2,y:2,c:"#5CC527"},{x:2,y:5,c:"#78D427"},{x:2,y:9,c:"#A7EC4C"},{x:2,y:10,c:"#BFF540"},{x:2,y:11,c:"#DBFB47"},{x:2,y:17,c:"#D4FC48"},
      {x:3,y:2,c:"#3CA726"},{x:3,y:9,c:"#B7F647"},{x:3,y:10,c:"#C7F843"},{x:3,y:17,c:"#D3FB49"},
      {x:4,y:2,c:"#E6FC56"},{x:4,y:8,c:"#77DB28"},{x:4,y:17,c:"#7CD82B"},{x:4,y:20,c:"#4D1A39"},{x:4,y:21,c:"#4F1A3C"},
      {x:5,y:2,c:"#E4FB5E"},{x:5,y:8,c:"#D0F947"},{x:5,y:20,c:"#EA6184"},{x:5,y:21,c:"#E76688"},{x:5,y:23,c:"#48193B"},{x:5,y:24,c:"#47183A"},
      {x:6,y:2,c:"#9CDE39"},{x:6,y:3,c:"#A4E933"},{x:6,y:7,c:"#6CCD28"},{x:6,y:20,c:"#E7567D"},{x:6,y:21,c:"#FC9EAA"},{x:6,y:23,c:"#E96785"},{x:6,y:24,c:"#EA6786"},
      {x:7,y:2,c:"#8EDB31"},{x:7,y:7,c:"#6BCB2A"},{x:7,y:20,c:"#FCA1A3"},{x:7,y:21,c:"#FCEDC6"},{x:7,y:22,c:"#FC9CA8"},{x:7,y:23,c:"#FC9BA8"},{x:7,y:25,c:"#FC9AA8"},
      {x:8,y:2,c:"#7AD42E"},{x:8,y:8,c:"#71CE29"},{x:8,y:22,c:"#FC9DA9"},{x:8,y:24,c:"#FDA1AC"},{x:8,y:25,c:"#FDA1AC"},{x:8,y:26,c:"#FB5B6B"},
      {x:9,y:4,c:"#6BCF24"},{x:9,y:7,c:"#9CE23B"},{x:9,y:22,c:"#FDA1AC"},{x:9,y:26,c:"#FB5768"},{x:9,y:27,c:"#FDA1AC"},
      {x:10,y:4,c:"#A2E733"},{x:10,y:13,c:"#62CB26"},{x:10,y:16,c:"#CDFB44"},{x:10,y:22,c:"#FDA1AC"},{x:10,y:23,c:"#FDA1AC"},{x:10,y:26,c:"#FC5E6F"},{x:10,y:27,c:"#FDA1AC"},
      {x:11,y:4,c:"#A5E638"},{x:11,y:11,c:"#64CB27"},{x:11,y:12,c:"#D2FA46"},{x:11,y:15,c:"#D0FA49"},{x:11,y:18,c:"#D9FC4B"},{x:11,y:22,c:"#FD9CA9"},{x:11,y:25,c:"#FDA1AC"},{x:11,y:26,c:"#FDA1AC"},{x:11,y:27,c:"#FDA1AC"},
      {x:12,y:3,c:"#57C229"},{x:12,y:4,c:"#27A337"},{x:12,y:5,c:"#A6E934"},{x:12,y:11,c:"#64CB2D"},{x:12,y:12,c:"#CEFA48"},{x:12,y:14,c:"#CEFB48"},{x:12,y:15,c:"#D0F94B"},{x:12,y:17,c:"#7AD82C"},{x:12,y:18,c:"#D7FB4C"},{x:12,y:22,c:"#FD9DA9"},{x:12,y:23,c:"#FDA1AC"},{x:12,y:24,c:"#FDA1AC"},{x:12,y:25,c:"#FDA1AC"},{x:12,y:26,c:"#FDA1AC"},
      {x:13,y:4,c:"#2AA435"},{x:13,y:5,c:"#27A137"},{x:13,y:11,c:"#65C92A"},{x:13,y:13,c:"#63CB28"},{x:13,y:15,c:"#C5F644"},{x:13,y:17,c:"#D8FA4B"},{x:13,y:18,c:"#CEF947"},{x:13,y:19,c:"#CAF94C"},{x:13,y:22,c:"#FC9EA9"},{x:13,y:23,c:"#FDA1AC"},{x:13,y:24,c:"#FDA1AC"},
      {x:14,y:11,c:"#5DBC34"},{x:14,y:13,c:"#82D62E"},{x:14,y:15,c:"#99EA54"},{x:14,y:16,c:"#C9F642"},{x:14,y:17,c:"#69D132"},{x:14,y:18,c:"#67C82B"},{x:14,y:22,c:"#FC9FAA"},{x:14,y:23,c:"#FDA1AC"},{x:14,y:24,c:"#FDA1AC"},
      {x:15,y:13,c:"#CFFA47"},{x:15,y:15,c:"#4FBB36"},{x:15,y:16,c:"#97E23A"},{x:15,y:22,c:"#FDA1AC"},{x:15,y:23,c:"#FDA1AC"},{x:15,y:24,c:"#FDA1AC"},
      {x:16,y:2,c:"#ADEE3A"},{x:16,y:3,c:"#BAF23E"},{x:16,y:7,c:"#CFF842"},{x:16,y:8,c:"#CDFA40"},{x:16,y:13,c:"#50BF2D"},{x:16,y:16,c:"#94E130"},{x:16,y:18,c:"#99E239"},{x:16,y:22,c:"#FDA2AC"},{x:16,y:23,c:"#FDA1AC"},{x:16,y:24,c:"#FDA1AC"},
      {x:17,y:2,c:"#AEEE34"},{x:17,y:3,c:"#B4F23D"},{x:17,y:7,c:"#4BBC2A"},{x:17,y:9,c:"#259F44"},{x:17,y:13,c:"#5CC82F"},{x:17,y:14,c:"#D3FA48"},{x:17,y:16,c:"#97E02F"},{x:17,y:18,c:"#96E331"},{x:17,y:22,c:"#FDA0AA"},{x:17,y:23,c:"#FDA1AC"},{x:17,y:24,c:"#FDA1AC"},
      {x:18,y:1,c:"#DBFC57"},{x:18,y:2,c:"#63C727"},{x:18,y:6,c:"#A9EC32"},{x:18,y:7,c:"#ADEE32"},{x:18,y:8,c:"#C3F53C"},{x:18,y:13,c:"#6FCE28"},{x:18,y:15,c:"#CEF848"},{x:18,y:22,c:"#FDA1AC"},{x:18,y:23,c:"#FDA1AC"},
      {x:19,y:0,c:"#BAF33B"},{x:19,y:1,c:"#65CB2A"},{x:19,y:6,c:"#1F9D3B"},{x:19,y:9,c:"#5CC82B"},{x:19,y:13,c:"#6CCD28"},{x:19,y:16,c:"#43B42C"},
      {x:20,y:0,c:"#229C37"},{x:20,y:2,c:"#217747"},{x:20,y:13,c:"#69CE2A"},{x:21,y:22,c:"#FD9FAA"},{x:21,y:26,c:"#FB6171"},
      {x:22,y:2,c:"#61CA28"},{x:22,y:5,c:"#B7F339"},{x:22,y:7,c:"#C4F140"},{x:22,y:8,c:"#C1F641"},
      {x:23,y:1,c:"#BDF246"},{x:23,y:5,c:"#BDF438"},{x:23,y:8,c:"#BDF33C"},
      {x:24,y:1,c:"#61C82A"},{x:24,y:5,c:"#ACED33"},{x:24,y:8,c:"#5BC328"},{x:24,y:9,c:"#5ECA2A"},{x:24,y:12,c:"#C9F15F"},{x:24,y:13,c:"#65C927"},
      {x:25,y:2,c:"#3EAD33"},{x:25,y:4,c:"#ABEB39"},{x:25,y:8,c:"#61C828"},{x:25,y:15,c:"#69CC29"},
      {x:26,y:4,c:"#ADED3A"},{x:26,y:12,c:"#67CC35"},{x:26,y:13,c:"#8CDF2E"},{x:26,y:14,c:"#66CB27"},
      {x:27,y:4,c:"#B0EF38"},{x:27,y:12,c:"#66CF2D"},{x:27,y:13,c:"#42B030"},{x:27,y:14,c:"#6CCC2C"},
      {x:28,y:4,c:"#B1EF38"},{x:28,y:12,c:"#60C929"},{x:28,y:15,c:"#66CB29"},
      {x:29,y:4,c:"#A0E937"},{x:29,y:5,c:"#A2E735"},
    ]

    const POTHOS_RAW = [
      {x:2,y:3,c:"#2BA137"},{x:2,y:4,c:"#B1F542"},{x:3,y:2,c:"#B1F542"},{x:3,y:3,c:"#2BA137"},{x:3,y:6,c:"#B1F542"},
      {x:4,y:1,c:"#B1F542"},{x:4,y:4,c:"#2BA137"},{x:4,y:5,c:"#B1F542"},{x:4,y:6,c:"#B1F542"},
      {x:5,y:1,c:"#B1F542"},{x:5,y:3,c:"#B1F542"},{x:5,y:5,c:"#2BA137"},{x:5,y:12,c:"#2BA137"},{x:5,y:13,c:"#B1F542"},
      {x:6,y:2,c:"#B1F542"},{x:6,y:3,c:"#B1F542"},{x:6,y:4,c:"#B1F542"},{x:6,y:5,c:"#B1F542"},
      {x:7,y:4,c:"#B1F542"},{x:7,y:5,c:"#B1F542"},
      {x:8,y:2,c:"#B1F542"},{x:8,y:3,c:"#B1F542"},{x:8,y:10,c:"#B1F542"},
      {x:9,y:2,c:"#B1F542"},{x:9,y:10,c:"#B1F542"},{x:9,y:11,c:"#2BA137"},
      {x:10,y:10,c:"#B1F542"},{x:10,y:11,c:"#2BA137"},{x:10,y:12,c:"#B1F542"},{x:10,y:13,c:"#2BA137"},
      {x:11,y:10,c:"#B1F542"},{x:11,y:11,c:"#2BA137"},{x:11,y:12,c:"#2BA137"},{x:11,y:13,c:"#2BA137"},
      {x:12,y:10,c:"#B1F542"},{x:12,y:11,c:"#2BA137"},{x:12,y:13,c:"#2BA137"},
      {x:15,y:10,c:"#B1F542"},{x:15,y:11,c:"#B1F542"},
      {x:16,y:8,c:"#B1F542"},{x:16,y:9,c:"#B1F542"},{x:16,y:10,c:"#B1F542"},{x:16,y:11,c:"#2BA137"},
      {x:17,y:4,c:"#B1F542"},{x:17,y:5,c:"#B1F542"},
      {x:18,y:4,c:"#B1F542"},{x:18,y:5,c:"#B1F542"},{x:18,y:6,c:"#2BA137"},
      {x:19,y:4,c:"#2BA137"},{x:19,y:6,c:"#B1F542"},{x:19,y:7,c:"#B1F542"},{x:19,y:8,c:"#B1F542"},
      {x:20,y:3,c:"#B1F542"},{x:20,y:6,c:"#B1F542"},{x:20,y:7,c:"#B1F542"},{x:20,y:8,c:"#B1F542"},{x:20,y:9,c:"#B1F542"},
      {x:21,y:3,c:"#B1F542"},{x:21,y:4,c:"#B1F542"},{x:21,y:8,c:"#2BA137"},{x:21,y:12,c:"#B1F542"},
      {x:22,y:14,c:"#B1F542"},{x:26,y:9,c:"#B1F542"},{x:26,y:10,c:"#B1F542"},
      {x:27,y:9,c:"#2BA137"},{x:27,y:10,c:"#2BA137"},{x:27,y:11,c:"#B1F542"},
      {x:28,y:11,c:"#B1F542"},{x:28,y:12,c:"#2BA137"},
      {x:6,y:15,c:"#2F7EB7"},{x:6,y:16,c:"#2F7EB7"},{x:6,y:17,c:"#2F7EB7"},
      {x:7,y:15,c:"#6EC6F5"},{x:7,y:16,c:"#2F7EB7"},{x:7,y:17,c:"#2F7EB7"},{x:7,y:18,c:"#2F7EB7"},{x:7,y:19,c:"#2F7EB7"},{x:7,y:20,c:"#2F7EB7"},
      {x:8,y:14,c:"#3A9AE0"},{x:8,y:16,c:"#6EC6F5"},{x:8,y:17,c:"#3A9AE0"},{x:8,y:18,c:"#3A9AE0"},{x:8,y:19,c:"#3A9AE0"},{x:8,y:20,c:"#3A9AE0"},{x:8,y:21,c:"#2F7EB7"},{x:8,y:22,c:"#2F7EB7"},
      {x:9,y:16,c:"#6EC6F5"},{x:9,y:17,c:"#3A9AE0"},{x:9,y:18,c:"#3A9AE0"},{x:9,y:19,c:"#3A9AE0"},{x:9,y:20,c:"#3A9AE0"},{x:9,y:21,c:"#FC5A68"},{x:9,y:22,c:"#3A9AE0"},{x:9,y:23,c:"#2F7EB7"},
      {x:10,y:16,c:"#2F7EB7"},{x:10,y:17,c:"#3A9AE0"},{x:10,y:21,c:"#FC5B6B"},{x:10,y:22,c:"#FC5B6A"},{x:10,y:23,c:"#3A9AE0"},{x:10,y:24,c:"#2F7EB7"},
      {x:11,y:16,c:"#2F7EB7"},{x:11,y:17,c:"#3A9AE0"},{x:11,y:21,c:"#3A9AE0"},{x:11,y:22,c:"#3A9AE0"},{x:11,y:23,c:"#3A9AE0"},{x:11,y:24,c:"#2F7EB7"},
      {x:12,y:17,c:"#3A9AE0"},{x:12,y:18,c:"#3A9AE0"},{x:12,y:21,c:"#3A9AE0"},{x:12,y:22,c:"#3A9AE0"},{x:12,y:23,c:"#3A9AE0"},{x:12,y:24,c:"#2F7EB7"},
      {x:13,y:17,c:"#3A9AE0"},{x:13,y:18,c:"#3A9AE0"},{x:13,y:19,c:"#3A9AE0"},{x:13,y:20,c:"#3A9AE0"},{x:13,y:21,c:"#3A9AE0"},{x:13,y:22,c:"#3A9AE0"},{x:13,y:23,c:"#3A9AE0"},{x:13,y:24,c:"#3A9AE0"},
      {x:14,y:17,c:"#3A9AE0"},{x:14,y:18,c:"#3A9AE0"},{x:14,y:19,c:"#3A9AE0"},{x:14,y:20,c:"#3A9AE0"},{x:14,y:22,c:"#3A9AE0"},{x:14,y:23,c:"#3A9AE0"},{x:14,y:24,c:"#3A9AE0"},
      {x:15,y:17,c:"#3A9AE0"},{x:15,y:18,c:"#3A9AE0"},{x:15,y:19,c:"#3A9AE0"},{x:15,y:20,c:"#3A9AE0"},{x:15,y:21,c:"#FC5B6B"},{x:15,y:23,c:"#3A9AE0"},{x:15,y:24,c:"#3A9AE0"},
      {x:16,y:16,c:"#6EC6F5"},{x:16,y:17,c:"#3A9AE0"},{x:16,y:18,c:"#3A9AE0"},{x:16,y:19,c:"#3A9AE0"},{x:16,y:20,c:"#3A9AE0"},{x:16,y:21,c:"#FC5B6B"},{x:16,y:23,c:"#3A9AE0"},{x:16,y:24,c:"#3A9AE0"},
      {x:17,y:17,c:"#3A9AE0"},{x:17,y:18,c:"#3A9AE0"},{x:17,y:19,c:"#3A9AE0"},{x:17,y:22,c:"#3A9AE0"},{x:17,y:23,c:"#3A9AE0"},{x:17,y:24,c:"#3A9AE0"},
      {x:18,y:17,c:"#3A9AE0"},{x:18,y:18,c:"#3A9AE0"},{x:18,y:19,c:"#3A9AE0"},{x:18,y:20,c:"#3A9AE0"},{x:18,y:21,c:"#3A9AE0"},{x:18,y:22,c:"#3A9AE0"},{x:18,y:23,c:"#3A9AE0"},{x:18,y:24,c:"#3A9AE0"},
      {x:21,y:21,c:"#FD5C6D"},{x:21,y:22,c:"#FC5B6B"},
      {x:22,y:16,c:"#6EC6F5"},{x:22,y:17,c:"#3A9AE0"},{x:22,y:18,c:"#3A9AE0"},{x:22,y:19,c:"#3A9AE0"},{x:22,y:20,c:"#3A9AE0"},{x:22,y:21,c:"#FD5E6E"},{x:22,y:22,c:"#FB5F6E"},{x:22,y:23,c:"#2F7EB7"},{x:22,y:24,c:"#2F7EB7"},
      {x:23,y:15,c:"#2F7EB7"},{x:23,y:16,c:"#6EC6F5"},{x:23,y:17,c:"#3A9AE0"},{x:23,y:18,c:"#3A9AE0"},{x:23,y:19,c:"#3A9AE0"},{x:23,y:20,c:"#3A9AE0"},{x:23,y:21,c:"#2F7EB7"},
      {x:24,y:15,c:"#2F7EB7"},{x:24,y:16,c:"#3A9AE0"},{x:24,y:17,c:"#3A9AE0"},{x:24,y:18,c:"#2F7EB7"},{x:24,y:19,c:"#2F7EB7"},{x:24,y:20,c:"#2F7EB7"},
    ]

    const POTHOS_EXCLUDE = new Set([
      "#40163B","#0B1126","#0B1128","#0A1128","#0A1027","#080E26","#100E27",
      "#151029","#0A0F27","#0A102B","#0C0E27","#0C0F27","#0C102B","#1C3848",
      "#051922","#195936","#2F5E79","#071923","#061923",
    ])

    const GW = canvas.width / S
    const GH = canvas.height / S

    function normalize(raw, W, H) {
      const xs = raw.map(p => p.x), ys = raw.map(p => p.y)
      const x0 = Math.min(...xs), y0 = Math.min(...ys)
      const x1 = Math.max(...xs), y1 = Math.max(...ys)
      const scale = Math.min((W - 1) / (x1 - x0 || 1), (H - 1) / (y1 - y0 || 1)) * 0.88
      const offX = Math.floor((W - (x1 - x0) * scale) / 2)
      const offY = Math.floor((H - (y1 - y0) * scale) / 2)
      return raw.map(p => ({
        x: Math.round((p.x - x0) * scale) + offX,
        y: Math.round((p.y - y0) * scale) + offY,
        c: p.c
      }))
    }

    function pastelise(hex) {
      const r = parseInt(hex.slice(1, 3), 16)
      const g = parseInt(hex.slice(3, 5), 16)
      const b = parseInt(hex.slice(5, 7), 16)
      return `rgb(${Math.round(r + (255 - r) * 0.22)},${Math.round(g + (255 - g) * 0.22)},${Math.round(b + (255 - b) * 0.22)})`
    }

    function shuffle(arr) {
      const a = [...arr]
      for (let i = a.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [a[i], a[j]] = [a[j], a[i]]
      }
      return a
    }

    function drawSparkle(cx, cy, color) {
      ctx.fillStyle = color
      ctx.fillRect(cx - 1, cy - 3, 2, 2)
      ctx.fillRect(cx - 1, cy + 1, 2, 2)
      ctx.fillRect(cx - 3, cy - 1, 2, 2)
      ctx.fillRect(cx + 1, cy - 1, 2, 2)
    }

    const avatars = [
      { pixels: normalize(MONSTERA_RAW, GW, GH), exclude: new Set([]),    frontier: "#ffb3c1", shimmer: "#fce4ec" },
      { pixels: normalize(POTHOS_RAW,   GW, GH), exclude: POTHOS_EXCLUDE, frontier: "#b3e5fc", shimmer: "#e8f5e9" },
    ]

    const LABELS = ["growing...","rendering...","hatching...","blooming...","emerging..."]
    let labelIdx = 0
    const CYCLE = 8000
    let startTime = null, lastAvatar = -1, order = [], sparkles = []

    const draw = (ts) => {
      if (!startTime) startTime = ts
      const total   = ts - startTime
      const idx     = Math.floor(total / CYCLE) % avatars.length
      const elapsed = total % CYCLE
      const progress = elapsed / CYCLE
      const av = avatars[idx]

      if (idx !== lastAvatar) {
        const filtered = av.pixels.filter(p => !av.exclude.has(p.c.toUpperCase()) && !av.exclude.has(p.c))
        order = shuffle(filtered)
        lastAvatar = idx
        sublbl.textContent = LABELS[labelIdx % LABELS.length]
        sublbl.style.color = "#ab6fc8"
        labelIdx++
        sparkles = []
      }

      ctx.clearRect(0, 0, canvas.width, canvas.height)

      let visible
      if (progress < 0.55)      visible = Math.floor((progress / 0.55) * order.length)
      else if (progress < 0.78) visible = order.length
      else {
        const d = (progress - 0.78) / 0.22
        visible = Math.floor((1 - d) * order.length)
      }
      const vCap = Math.min(visible, order.length)

      for (let i = 0; i < vCap; i++) {
        const { x, y, c } = order[i]
        ctx.fillStyle = Math.random() < 0.02 ? av.shimmer : pastelise(c)
        ctx.fillRect(x * S, y * S, S, S)
        ctx.fillStyle = "rgba(255,255,255,0.18)"
        ctx.fillRect(x * S, y * S, 2, 2)
      }

      const fCount = Math.min(10, vCap)
      for (let i = vCap - fCount; i < vCap; i++) {
        if (i < 0) continue
        const { x, y } = order[i]
        ctx.fillStyle = av.frontier
        ctx.fillRect(x * S, y * S, S, S)
        ctx.fillStyle = "rgba(255,255,255,0.6)"
        ctx.fillRect(x * S, y * S, 2, 2)
        if (Math.random() < 0.3) sparkles.push({ cx: x * S + S / 2, cy: y * S + S / 2, life: 8, color: av.frontier })
      }

      sparkles = sparkles.filter(s => s.life > 0)
      for (const s of sparkles) {
        ctx.globalAlpha = s.life / 8
        drawSparkle(s.cx, s.cy, s.color)
        s.life--
      }
      ctx.globalAlpha = 1

      requestAnimationFrame(draw)
    }

    requestAnimationFrame(draw)
  }
}
