const form = document.getElementById('assessment-form')
const result = document.getElementById('result')

form.addEventListener('submit', async (e)=>{
  e.preventDefault()
  const data = new FormData(form)
  const payload = Object.fromEntries(data.entries())
  payload.data_readiness = Number(payload.data_readiness)

  result.textContent = 'Running assessment...'

  try{
    const res = await fetch('http://localhost:8000/assess', {
      method: 'POST',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify(payload)
    })
    const json = await res.json()
    result.innerHTML = `<strong>Score:</strong> ${json.score}<br/><strong>Notes:</strong> ${json.notes}`
  }catch(err){
    result.textContent = 'Unable to reach assessment service. Start the backend and try again.'
  }
})
