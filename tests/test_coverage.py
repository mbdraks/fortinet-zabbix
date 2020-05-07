import markdown_table

ALL_OIDS_FILENAME = './tmp/FORTINET-FORTIGATE-MIB.oids.md'
FOS_TEMPLATE_FILENAME = './Template Net Fortinet FortiGate SNMPv2.xml'

with open(ALL_OIDS_FILENAME) as f:
    oids = f.readlines()

parsed_oids = []
parsed_oids_numbers = []
for line in oids:
    line = line.split()
    d = {}
    d[line[0]] = line[1]
    parsed_oids.append(d)
    parsed_oids_numbers.append(line[1])

with open(FOS_TEMPLATE_FILENAME) as f:
    template = f.readlines()

parsed_template = []
for line in template:
    if 'snmp_oid' in line:
        if not 'discovery' in line:
            line = line.split('<snmp_oid>')[1]
            line = line.split('</snmp_oid>')[0]
            parsed_template.append(line)

results = []
for line in parsed_oids_numbers:
    for template_line in parsed_template:
        if line in template_line:
            results.append(line)
results = set(results)

parsed_oids_numbers = set(parsed_oids_numbers)
missing = parsed_oids_numbers.difference(results)

combined_results = []
for dict_line in parsed_oids:
    for oid_name, oid_number in dict_line.items():
        for line in results:
            if line == oid_number:
                combined_results.append(dict_line)

combined_missing = []
for dict_line in parsed_oids:
    for oid_name, oid_number in dict_line.items():
        for line in missing:
            if line == oid_number:
                combined_missing.append(dict_line)

coverage_list = []
for line in combined_results:
    for key, value in line.items():
        temp = [key,value]
        coverage_list.append(temp)

headers = ["Name","OID"]
coverage = markdown_table.render(headers,coverage_list)



missing_list = []
for line in combined_missing:
    for key, value in line.items():
        temp = [key,value]
        missing_list.append(temp)

missing = markdown_table.render(headers,missing_list)

total_coverage = len(combined_results)
full_oid = len(parsed_oids)
coverage_percentage = (total_coverage/full_oid)*100

summary = f''' 

# Coverage Summary

    Full OID list: { full_oid }
    Coverage: { total_coverage } ({coverage_percentage:.2f}%)

# Coverage Detailed

'''

coverage_final = summary + coverage

missing_header = f'''

# Missing Detailed

'''

coverage_final = summary + coverage + missing_header + missing

with open("COVERAGE.md", "w") as f:
    f.write(coverage_final)