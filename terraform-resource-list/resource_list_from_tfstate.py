import json
from subprocess import call

def get_leaves(item):
    leaves = {}
    for kl,vl in item.items():
            if isinstance(vl, dict):
                leaves.update(get_leaves(vl))
            elif isinstance(vl, list):
                continue
            else:
                if kl == "name" or kl == "type" or kl == "id" or kl == "arn" :
                    leaves.update({kl: vl})
    return leaves
with open('example.json', newline='') as f, open('resource-list.csv', 'w', newline='') as f_out:
    obj = json.load(f)
    for k,v in obj.items():
        if k == 'modules':
            for item1 in v:
                if isinstance(item1, dict):
                    for res, det in item1.items():
                        if res == "resources":
                            if isinstance(det, dict):
                                for k2,v2 in det.items():
                                    f_out.write(k2)
                                    f_out.write(",")
                                    resource_details = {}
                                    resource_details = get_leaves(v2)
                                    for item, value in resource_details.items():
                                        f_out.write("%s = " % item)
                                        f_out.write("%s," %value)
f_out.close()
f.close()
