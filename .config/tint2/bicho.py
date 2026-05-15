import requests
from bs4 import BeautifulSoup

# URL to fetch the results
URL = 'https://www.eojogodobicho.com/jogo/get_resultados_hoje.php'

# Number to Name Mapping
number_names = {
    '01': 'avestruz 🦤', '02': 'águia 🦅', '03': 'burro \U0001FACF', '04': 'borboleta 🦋', '05': 'cachorro 🐕',
    '06': 'cabra 🐐', '07': 'carneiro 🐏', '08': 'camelo 🐫', '09': 'cobra 🐍', '10': 'coelho 🐇',
    '11': 'cavalo 🐎', '12': 'elefante 🐘', '13': 'galo 🐓', '14': 'gato 🐈', '15': 'jacaré 🐊',
    '16': 'leão 🦁', '17': 'macaco 🐒', '18': 'porco 🐖', '19': 'pavão 🦚', '20': 'peru 🦃',
    '21': 'touro 🐂', '22': 'tigre 🐅', '23': 'urso 🐻', '24': 'veado 🦌', '25': 'vaca 🐄'
}

def fetch_results(url):
    response = requests.get(url)
    response.raise_for_status()  # Raise an HTTPError for bad responses
    return response.text

def parse_results(html):
    soup = BeautifulSoup(html, 'html.parser')
    table = soup.find('table')
    
    if not table:
        return []

    trs = table.find_all('tr')
    
    if not trs:
        return []

    depois_do_cabecalho = False
    results = []
    for tr in trs:
        for td in tr.find_all('td'):
            result = td.get_text().strip()
            if result and not result.startswith('0000-') and '-' in result:
                number = result.split('-')[1].strip()
                if number.isdigit():
                    results.append(number)
                    depois_do_cabecalho = True
        if depois_do_cabecalho: break
    return results

def number_to_name(number, number_names):
    return number_names.get(number, "Unknown")

if __name__ == "__main__":
    html_content = fetch_results(URL)
    parsed_results = parse_results(html_content)

    if parsed_results:
        last_number = parsed_results[-1]
        name = number_to_name(last_number, number_names)
        print(f'<span foreground="#00ff5f" weight="bold">{last_number}</span> {name} 🇧🇷')
    else:
        print("No valid results found.")
