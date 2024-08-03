
--LOOK UP DEFINITION OF ALL ROUND 
SELECT 
    R.RoundID, 
    GROUP_CONCAT(DISTINCT R.RoundType) AS RoundTypes,
    GROUP_CONCAT(DISTINCT R.RangeID) AS RangeIDs,
    SUM(R.PossibleScore) AS TotalPossibleScore
FROM RoundData R
JOIN RangeData Rd ON R.RangeID = Rd.RangeID
GROUP BY R.RoundID;


--LOOK UP DEFINITION OF ONE ROUND
SELECT 
    R.RoundID, 
    GROUP_CONCAT(DISTINCT R.RoundType) AS RoundTypes,
    GROUP_CONCAT(DISTINCT R.RangeID) AS RangeIDs,
    SUM(R.PossibleScore) AS TotalPossibleScore
FROM RoundData R
JOIN RangeData Rd ON R.RangeID = Rd.RangeID
WHERE R.RoundID = "HO"
GROUP BY R.RoundID;


--LOOK UP IN DETAILS OF BASE ROUND AND EQUIVALENT ROUND
SELECT 
    R.RoundID, 
    R.RoundType, 
    RT.RoundTypeDesc, 
    R.RangeID, 
    R.RoundName, 
    R.PossibleScore, 
    Rd.Distance, 
    Rd.ArrowNumber, 
    Rd.TargetFace
FROM RoundData R
JOIN RoundTypeData RT ON R.RoundType = RT.RoundType
JOIN RangeData Rd ON R.RangeID = Rd.RangeID
WHERE R.RoundID = "HO";


-- ARCHER LOOK UP HIS TOTAL SCORE IN ALL ROUNDS HE PARTICIPATED
SELECT s.ArcherID, a.ArcName, s.RoundID, r.RoundName, SUM(e.Arrow1 + e.Arrow2 + e.Arrow3 + e.Arrow4 + e.Arrow5 + e.Arrow6) AS TotalScore
FROM SystemData s
JOIN ArcherData a ON s.ArcherID = a.ArcherID
JOIN EndData e ON s.RoundID = e.RoundID AND s.RangeID = e.RangeID AND s.EndID = e.EndID
JOIN RoundData r ON s.RoundID = r.RoundID AND s.RangeID = r.RangeID
WHERE s.ArcherID = "A2"
GROUP BY s.ArcherID, a.ArcName, s.RoundID, r.RoundName
ORDER BY s.RoundID;


--ARCHER LOOK UP HIS TOTAL SCORE IN ONE ROUND HE PARTICIPATED
SELECT s.ArcherID, a.ArcName, s.RoundID, r.RoundName, e.Arrow1, e.Arrow2, e.Arrow3, e.Arrow4, e.Arrow5, e.Arrow6,
       (e.Arrow1 + e.Arrow2 + e.Arrow3 + e.Arrow4 + e.Arrow5 + e.Arrow6) AS RoundScore
FROM SystemData s
JOIN ArcherData a ON s.ArcherID = a.ArcherID
JOIN EndData e ON s.RoundID = e.RoundID AND s.RangeID = e.RangeID AND s.EndID = e.EndID
JOIN RoundData r ON s.RoundID = r.RoundID AND s.RangeID = r.RangeID
WHERE s.ArcherID = "A2" AND s.RoundID = "PE"  --AND s.DateInfo BETWEEN "2023-12-12" AND "2025-12-12" (Add this for specific date)
ORDER BY s.EndID;


-- List Scores for Each End of a Round for specific Archer (A1)
SELECT 
    sd.ArcherID, ad.ArcName, sd.RoundID, sd.RangeID, sd.EndID,
    ed.Arrow1, ed.Arrow2, ed.Arrow3, ed.Arrow4, ed.Arrow5, ed.Arrow6,
    (ed.Arrow1 + ed.Arrow2 + ed.Arrow3 + ed.Arrow4 + ed.Arrow5 + ed.Arrow6) AS TotalScore
FROM SystemData sd
JOIN EndData ed ON sd.RoundID = ed.RoundID AND sd.RangeID = ed.RangeID AND sd.EndID = ed.EndID
JOIN ArcherData ad ON sd.ArcherID = ad.ArcherID
WHERE sd.ArcherID = 'A1' AND sd.RoundID ='BB';


--IDENTIFY THE WINNER OF A COMPETITION
SELECT 
    c.CompID,
    c.CompName,
    s.ArcherID,
    a.ArcName,
    SUM(e.Arrow1 + e.Arrow2 + e.Arrow3 + e.Arrow4 + e.Arrow5 + e.Arrow6) AS TotalScore
FROM SystemData s
JOIN ArcherData a ON s.ArcherID = a.ArcherID
JOIN EndData e ON s.RoundID = e.RoundID AND s.RangeID = e.RangeID AND s.EndID = e.EndID
JOIN Competition c ON s.CompID = c.CompID
WHERE s.CompID = "C2"
GROUP BY c.CompID, c.CompName, s.ArcherID, a.ArcName
ORDER BY TotalScore DESC;
LIMIT 1; --ONLY DISPLAY THE WINNER (REMOVE THIS TO DISPLAY THE RANKING IN THE COMPETITION)


--IDENTIFY THE WINNER OF A CHAMPIONSHIP
SELECT 
    ch.ChampionShipID,
    ch.ChampionShipName,
    s.ArcherID,
    a.ArcName,
    SUM(e.Arrow1 + e.Arrow2 + e.Arrow3 + e.Arrow4 + e.Arrow5 + e.Arrow6) AS TotalScore
FROM SystemData s
JOIN ArcherData a ON s.ArcherID = a.ArcherID
JOIN EndData e ON s.RoundID = e.RoundID AND s.RangeID = e.RangeID AND s.EndID = e.EndID
JOIN Competition c ON s.CompID = c.CompID
JOIN ChampionShip ch ON c.ChampionShipID = ch.ChampionShipID
WHERE ch.ChampionShipID = "AUS"
GROUP BY ch.ChampionShipID, ch.ChampionShipName, s.ArcherID, a.ArcName
ORDER BY TotalScore DESC
LIMIT 1;


--Show the list of scores of an archer that haven't been approved
SELECT 
    s.ArcherID,
    a.ArcName,
    s.RoundID,
    s.RangeID,
    s.EndID,
    e.Arrow1,
    e.Arrow2,
    e.Arrow3,
    e.Arrow4,
    e.Arrow5,
    e.Arrow6,
    (e.Arrow1 + e.Arrow2 + e.Arrow3 + e.Arrow4 + e.Arrow5 + e.Arrow6) AS TotalScore
FROM SystemData s
JOIN ArcherData a ON s.ArcherID = a.ArcherID
JOIN EndData e ON s.RoundID = e.RoundID AND s.RangeID = e.RangeID AND s.EndID = e.EndID
WHERE e.Approved = FALSE AND s.ArcherID = "A1";


--UPDATE APPROVAL STATUS
UPDATE EndData
SET Approved = TRUE
WHERE RoundID = " "
  AND RangeID = " "
  AND EndID = " ";
