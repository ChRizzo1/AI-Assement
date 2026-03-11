from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/assess', methods=['POST'])
def assess():
    data = request.get_json()

    # Extract data from the request
    company_size = data.get('company_size')
    ai_maturity = data.get('ai_maturity')
    industry = data.get('industry', 'Unknown')
    ai_challenge = data.get('ai_challenge', '')

    # Calculate a simple score based on the inputs
    score = 0

    if company_size in ['201-500', '500+']:
        score += 3
    elif company_size in ['51-200']:
        score += 2
    else:
        score += 1

    if ai_maturity == 'advanced':
        score += 5
    elif ai_maturity == 'scaling':
        score += 4
    elif ai_maturity == 'piloting':
        score += 3
    elif ai_maturity == 'exploring':
        score += 2
    else:
        score += 1

    # Generate a recommendation based on the score
    if score > 8:
        recommendation = "Your organization is highly ready for AI adoption."
    elif score > 5:
        recommendation = "Your organization is moderately ready for AI adoption."
    else:
        recommendation = "Your organization needs to improve its AI readiness."

    return jsonify({
        "score": score,
        "recommendation": recommendation,
        "industry": industry,
        "ai_challenge": ai_challenge
    })

if __name__ == '__main__':
    app.run(port=8000)