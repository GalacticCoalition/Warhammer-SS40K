import { classes } from 'common/react';
import { useBackend } from "../backend";
import { Flex, Icon, Section, Table, Tooltip, Button } from "../components";
import { Window } from "../layouts";

const commandJobs = [
  "Head of Personnel",
  "Head of Security",
  "Chief Engineer",
  "Research Director",
  "Chief Medical Officer",
];

export const RecordManifest = (props, context) => {
  const { data: { manifest, positions } } = useBackend(context);
  const { act } = useBackend(context);

  return (
    <Window title="All crew with exploitables" width={450} height={500}>
      <Window.Content scrollable>
        {Object.entries(manifest).map(([dept, crew]) => (
          <Section
            className={"CrewManifest--" + dept}
            key={dept}
            title={dept}
          >
            <Table>
              {Object.entries(crew).map(([crewIndex, crewMember]) => (
                <Table.Row key={crewIndex}>
                  <Table.Cell className={"CrewManifest__Cell"}>
                    {crewMember.name}
                  </Table.Cell>
                  <Table.Cell>
                    <Button
                      content="Show exploitables"
                      onClick={() => act("show_exploitables", {
                        exploitable_id: crewMember.name,
                      })} />
                  </Table.Cell>
                  <Table.Cell
                    className={classes([
                      "CrewManifest__Cell",
                      "CrewManifest__Icons",
                    ])}
                    collapsing
                  >
                    {positions[dept].exceptions.includes(crewMember.rank) && (

                      <Tooltip
                        content="No position limit"
                        position="bottom"
                      >
                        <Icon className="CrewManifest__Icon" name="infinity" />
                      </Tooltip>
                    )}
                    {crewMember.rank === "Captain" && (
                      <Tooltip
                        content="Captain"
                        position="bottom"
                      >
                        <Icon
                          className={classes([
                            "CrewManifest__Icon",
                            "CrewManifest__Icon--Command",
                          ])}
                          name="star"
                        />
                      </Tooltip>
                    )}
                    {commandJobs.includes(crewMember.rank) && (
                      <Tooltip
                        content="Member of command"
                        position="bottom"
                      >
                        <Icon
                          className={classes([
                            "CrewManifest__Icon",
                            "CrewManifest__Icon--Command",
                            "CrewManifest__Icon--Chevron",
                          ])}
                          name="chevron-up"
                        />
                      </Tooltip>
                    )}
                  </Table.Cell>
                  <Table.Cell
                    className={classes([
                      "CrewManifest__Cell",
                      "CrewManifest__Cell--Rank",
                    ])}
                    collapsing
                  >
                    {crewMember.rank}
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          </Section>
        ))}
      </Window.Content>
    </Window>
  );
};
