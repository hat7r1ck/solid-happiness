
```xml
<form>
  <label>MITRE Incident Investigation Dashboard</label>
  <fieldset submitButton="false">
    <input type="text" token="entity">
      <label>Entity (host, user, IP)</label>
    </input>
    <input type="dropdown" token="mitre_tactic" searchWhenChanged="true">
      <label>MITRE Tactic (optional)</label>
      <search>
        <query>
          from datamodel: "Risk"."All_Risk"
          | search annotations=*ctcf*
          | eval _norm = replace(search_name, "\s*-\s*", "-")
          | eval _parts = split(_norm, "-")
          | eval rule_name = case(
                mvcount(_parts) > 3, mvjoin(mvindex(_parts, 1, mvcount(_parts) - 2), "-"),
                mvcount(_parts) == 2, mvindex(_parts, 1),
                true(), null()
            )
          | rex field=_norm "^[^-]+-\s*(?&lt;rule_name_alt&gt;.*?)\s*-[^-]+$"
          | eval rule_name = trim(coalesce(rule_name, rule_name_alt, _norm))
          | fields _norm _parts rule_name_alt
          | rename rule_name as "Rule Name"
          | rename annotations.mitre_attack.mitre_tactic_id as "MITRE Tactic ID"
          | rename annotations.mitre_attack.mitre_tactic as "MITRE Tactic"
          | rename annotations.mitre_attack.mitre_technique as "MITRE Technique"
          | rename annotations.mitre_attack.mitre_technique_id as "MITRE Technique ID"
          | rename calculated_risk_score as "Risk Score"
          | rename annotations.wf_data_source as "Data Source"
          | stats count by "MITRE Tactic"
        </query>
      </search>
      <fieldForLabel>MITRE Tactic</fieldForLabel>
      <fieldForValue>MITRE Tactic</fieldForValue>
    </input>
  </fieldset>
  <row>
    <panel>
      <title>All Rules/Alerts for Entity</title>
      <table>
        <search>
          <query>
            from datamodel: "Risk"."All_Risk"
            | search annotations=*ctcf* $entity$
            | eval _norm = replace(search_name, "\s*-\s*", "-")
            | eval _parts = split(_norm, "-")
            | eval rule_name = case(
                  mvcount(_parts) > 3, mvjoin(mvindex(_parts, 1, mvcount(_parts) - 2), "-"),
                  mvcount(_parts) == 2, mvindex(_parts, 1),
                  true(), null()
              )
            | rex field=_norm "^[^-]+-\s*(?&lt;rule_name_alt&gt;.*?)\s*-[^-]+$"
            | eval rule_name = trim(coalesce(rule_name, rule_name_alt, _norm))
            | rename rule_name as "Rule Name"
            | rename annotations.mitre_attack.mitre_tactic_id as "MITRE Tactic ID"
            | rename annotations.mitre_attack.mitre_tactic as "MITRE Tactic"
            | rename annotations.mitre_attack.mitre_technique as "MITRE Technique"
            | rename annotations.mitre_attack.mitre_technique_id as "MITRE Technique ID"
            | rename calculated_risk_score as "Risk Score"
            | rename annotations.wf_data_source as "Data Source"
            | search "MITRE Tactic"="$mitre_tactic$"
            | table "Rule Name", "MITRE Tactic", "MITRE Technique", "Risk Score", "Data Source", _time
          </query>
        </search>
      </table>
    </panel>
  </row>
</form>
```

***


```xml
<form>
  <label>MITRE Rule & Entity Investigation Widget</label>
  <fieldset submitButton="false">
    <input type="text" token="entity">
      <label>Entity (host, user, IP)</label>
    </input>
    <input type="dropdown" token="mitre_tactic" searchWhenChanged="true">
      <label>MITRE Tactic (optional)</label>
      <search>
        <query>
          from datamodel: "Risk"."All_Risk"
          | search annotations=*ctcf*
          | eval _norm = replace(search_name, "\s*-\s*", "-")
          | eval _parts = split(_norm, "-")
          | eval rule_name = case(
                mvcount(_parts) > 3, mvjoin(mvindex(_parts, 1, mvcount(_parts) - 2), "-"),
                mvcount(_parts) == 2, mvindex(_parts, 1),
                true(), null()
            )
          | rex field=_norm "^[^-]+-\s*(?&lt;rule_name_alt&gt;.*?)\s*-[^-]+$"
          | eval rule_name = trim(coalesce(rule_name, rule_name_alt, _norm))
          | rename rule_name as "Rule Name"
          | rename annotations.mitre_attack.mitre_tactic_id as "MITRE Tactic ID"
          | rename annotations.mitre_attack.mitre_tactic as "MITRE Tactic"
          | rename annotations.mitre_attack.mitre_technique as "MITRE Technique"
          | rename annotations.mitre_attack.mitre_technique_id as "MITRE Technique ID"
          | rename calculated_risk_score as "Risk Score"
          | rename annotations.wf_data_source as "Data Source"
          | stats count by "MITRE Tactic"
        </query>
      </search>
      <fieldForLabel>MITRE Tactic</fieldForLabel>
      <fieldForValue>MITRE Tactic</fieldForValue>
    </input>
  </fieldset>
  <row>
    <panel>
      <title>Triggered Rules (with MITRE mapping)</title>
      <table>
        <search>
          <query>
            from datamodel: "Risk"."All_Risk"
            | search annotations=*ctcf* $entity$
            | eval _norm = replace(search_name, "\s*-\s*", "-")
            | eval _parts = split(_norm, "-")
            | eval rule_name = case(
                  mvcount(_parts) > 3, mvjoin(mvindex(_parts, 1, mvcount(_parts) - 2), "-"),
                  mvcount(_parts) == 2, mvindex(_parts, 1),
                  true(), null()
              )
            | rex field=_norm "^[^-]+-\s*(?&lt;rule_name_alt&gt;.*?)\s*-[^-]+$"
            | eval rule_name = trim(coalesce(rule_name, rule_name_alt, _norm))
            | rename rule_name as "Rule Name"
            | rename annotations.mitre_attack.mitre_tactic_id as "MITRE Tactic ID"
            | rename annotations.mitre_attack.mitre_tactic as "MITRE Tactic"
            | rename annotations.mitre_attack.mitre_technique as "MITRE Technique"
            | rename annotations.mitre_attack.mitre_technique_id as "MITRE Technique ID"
            | rename calculated_risk_score as "Risk Score"
            | rename annotations.wf_data_source as "Data Source"
            | search "MITRE Tactic"="$mitre_tactic$"
            | table "Rule Name", "MITRE Tactic", "MITRE Technique", "Risk Score", "Data Source", _time
          </query>
        </search>
      </table>
    </panel>
  </row>
</form>
```
