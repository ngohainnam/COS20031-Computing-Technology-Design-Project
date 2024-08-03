
--QUERIES-- Archers Looking up their own scores/competitions they participated in 
SELECT Sys.ArcherID, Sys.ClassID, Sys.EquipID, Sys.RoundID, Sys.RangeID, Sys.EndID, Sys.DateInfo,
       E.Arrow1, E.Arrow2, E.Arrow3, E.Arrow4, E.Arrow5, E.Arrow6
FROM SystemData Sys
JOIN EndData E ON Sys.RoundID = E.RoundID AND Sys.RangeID = E.RangeID AND Sys.EndID = E.EndID
WHERE Sys.ArcherID = 'A1' AND Sys.CompID = 'C1';

-- or
SELECT sd.ArcherID, ad.ArcName, sd.CompID, sd.RoundID, sd.RangeID, sd.EndID, ed.Arrow1, ed.Arrow2, ed.Arrow3, ed.Arrow4, ed.Arrow5, ed.Arrow6
FROM SystemData sd
JOIN EndData ed ON sd.RoundID = ed.RoundID AND sd.RangeID = ed.RangeID AND sd.EndID = ed.EndID
JOIN ArcherData ad ON sd.ArcherID = ad.ArcherID
WHERE sd.ArcherID = 'A1' AND sd.CompID = 'C1';


--QUERIES-- Archers Looking up the definition of rounds
SELECT RO.RoundID, RO.RangeID, RO.RoundName, RO.PossibleScore, R.Distance, R.ArrowNumber, R.TargetFace
FROM RoundData RO
JOIN RangeData R ON RO.RangeID = R.RangeID;


--QUERIES-- Archers Looking up their own scores and the total score of the round they shot
SELECT Sys.ArcherID, Sys.ClassID, Sys.EquipID, Sys.RoundID, Sys.DateInfo,
  SUM(E.Arrow1 + E.Arrow2 + E.Arrow3 + E.Arrow4 + E.Arrow5 + E.Arrow6) AS TotalRoundScore
FROM SystemData Sys
JOIN EndData E ON Sys.EndID = E.EndID
WHERE Sys.ArcherID = 'A1' AND Sys.RoundID = 'HO';


--QUERIES-- Archers Looking up their own scores and the total score for their range of a round
SELECT Sys.ArcherID, Sys.ClassID, Sys.EquipID, Sys.RoundID, Sys.DateInfo,
  SUM(E.Arrow1 + E.Arrow2 + E.Arrow3 + E.Arrow4 + E.Arrow5 + E.Arrow6) AS TotalRangeScore
FROM SystemData Sys
JOIN EndData E ON Sys.EndID = E.EndID
WHERE Sys.ArcherID = 'A1' AND Sys.RangeID = 'HO50';


--QUERIES-- Archers Looking up club competitions only (not individual scores)
SELECT Sys.ArcherID, Sys.ClassID, Sys.EquipID, Sys.RoundID, Sys.RangeID, Sys.EndID, Sys.CompID, Sys.DateInfo,
       E.Arrow1, E.Arrow2, E.Arrow3, E.Arrow4, E.Arrow5, E.Arrow6
FROM SystemData Sys
JOIN EndData E ON Sys.RoundID = E.RoundID AND Sys.RangeID = E.RangeID AND Sys.EndID = E.EndID;


--QUERIES-- find the equivalent round of a specific round
SELECT *
FROM RoundData
WHERE RoundID = 'HO' AND RoundType <> 'Base';

--or find the equivalent round list (of all existing round)
SELECT *
FROM RoundData
WHERE RoundType <> 'Base';


--QUERIES-- find which competition belongs to which championship
Select * from Competition;

-------------------------------------------------------------------------------------------------------------------
--ADDITIONAL QUERIES:
-- List Scores for Each End for specific Archer (A1)
SELECT 
    sd.ArcherID, ad.ArcName, sd.RoundID, sd.RangeID, sd.EndID,
    ed.Arrow1, ed.Arrow2, ed.Arrow3, ed.Arrow4, ed.Arrow5, ed.Arrow6,
    (ed.Arrow1 + ed.Arrow2 + ed.Arrow3 + ed.Arrow4 + ed.Arrow5 + ed.Arrow6) AS TotalScore
FROM SystemData sd
JOIN EndData ed ON sd.RoundID = ed.RoundID AND sd.RangeID = ed.RangeID AND sd.EndID = ed.EndID
JOIN ArcherData ad ON sd.ArcherID = ad.ArcherID
WHERE sd.ArcherID = 'A1';

--display the performance of all archers in a specific end (only work if we manage to insert the correct code for each end)
SELECT 
    sd.ArcherID, ad.ArcName, sd.RoundID, sd.RangeID, sd.EndID,
    ed.Arrow1, ed.Arrow2, ed.Arrow3, ed.Arrow4, ed.Arrow5, ed.Arrow6,
    (ed.Arrow1 + ed.Arrow2 + ed.Arrow3 + ed.Arrow4 + ed.Arrow5 + ed.Arrow6) AS TotalScore
FROM SystemData sd
JOIN EndData ed ON sd.RoundID = ed.RoundID AND sd.RangeID = ed.RangeID AND sd.EndID = ed.EndID
JOIN ArcherData ad ON sd.ArcherID = ad.ArcherID
WHERE sd.EndID LIKE 'A%D1';  --sd.RoundID = 'HO' can add this to specify which round as well


--display personal best in a competition
SELECT 
    sd.ArcherID, ad.ArcName, sd.CompID,
    MAX(ed.Arrow1 + ed.Arrow2 + ed.Arrow3 + ed.Arrow4 + ed.Arrow5 + ed.Arrow6) AS PersonalBest
FROM SystemData sd
JOIN EndData ed ON sd.RoundID = ed.RoundID AND sd.RangeID = ed.RangeID AND sd.EndID = ed.EndID
JOIN ArcherData ad ON sd.ArcherID = ad.ArcherID
GROUP BY sd.ArcherID, ad.ArcName, sd.CompID
ORDER BY PersonalBest DESC;

--display personal best in a competition  (delete the where clause to display all archers)
SELECT 
    sd.ArcherID, ad.ArcName, sd.RoundID,
    MAX(ed.Arrow1 + ed.Arrow2 + ed.Arrow3 + ed.Arrow4 + ed.Arrow5 + ed.Arrow6) AS PersonalBest
FROM SystemData sd
JOIN EndData ed ON sd.RoundID = ed.RoundID AND sd.RangeID = ed.RangeID AND sd.EndID = ed.EndID
JOIN ArcherData ad ON sd.ArcherID = ad.ArcherID
WHERE sd.ArcherID = 'A1'
GROUP BY sd.ArcherID, ad.ArcName, sd.RoundID
ORDER BY PersonalBest DESC;


--ADDED QUERIES (SCORES BY DATE)
SELECT Sys.ArcherID, Sys.ClassID, Sys.EquipID, Sys.RoundID, Sys.RangeID, Sys.EndID, Sys.CompID, Sys.DateInfo, E.Arrow1, E.Arrow2, E.Arrow3, E.Arrow4, E.Arrow5, E.Arrow6 
FROM SystemData Sys 
JOIN EndData E ON Sys.RoundID = E.RoundID AND Sys.RangeID = E.RangeID AND Sys.EndID = E.EndID 
WHERE Sys.DateInfo = '2024-04-08';
--or if just in ascending or descending order-- 
SELECT Sys.ArcherID, Sys.ClassID, Sys.EquipID, Sys.RoundID, Sys.RangeID, Sys.EndID, Sys.CompID, Sys.DateInfo, E.Arrow1, E.Arrow2, E.Arrow3, E.Arrow4, E.Arrow5, E.Arrow6 
FROM SystemData Sys 
JOIN EndData E ON Sys.RoundID = E.RoundID AND Sys.RangeID = E.RangeID AND Sys.EndID = E.EndID 
ORDER BY Sys.DateInfo DESC; --change if you want scores that were shot the earliest
--ALL SCORES OF EVERY ARCHER (SCORE OF EACH RANGE) BY HIGHEST TO LOWEST)
SELECT Sys.ArcherID, Sys.ClassID, Sys.EquipID, Sys.RoundID, Sys.RangeID, Sys.CompID, Sys.DateInfo,E.Arrow1, E.Arrow2, E.Arrow3,E.Arrow4,E.Arrow5,E.Arrow6,
       SUM(E.Arrow1 + E.Arrow2 + E.Arrow3 + E.Arrow4 + E.Arrow5 + E.Arrow6) AS TotalRangeScore
FROM SystemData Sys 
JOIN EndData E ON Sys.RoundID = E.RoundID AND Sys.RangeID = E.RangeID AND Sys.EndID = E.EndID 
GROUP BY Sys.ArcherID, Sys.ClassID, Sys.EquipID, Sys.RoundID, Sys.RangeID, Sys.CompID, Sys.DateInfo
ORDER BY TotalRangeScore DESC
--END OF SOURCE CODE





--ARCHER LOOK UP THEIR OWN SCORE OVER TIME
SELECT 
    SD.ArcherID,AD.ArcName AS ArcherName,RD.RoundType,E.EquipDesc AS Equipment,C.ClassDesc AS Division,SD.DateInfo AS DateInfo,
    ED.Arrow1,ED.Arrow2,ED.Arrow3,ED.Arrow4,ED.Arrow5,ED.Arrow6,RD.PossibleScore,
    (ED.Arrow1 + ED.Arrow2 + ED.Arrow3 + ED.Arrow4 + ED.Arrow5 + ED.Arrow6) AS TotalScore
FROM SystemData SD
JOIN ArcherData AD ON SD.ArcherID = AD.ArcherID
JOIN Category CT ON SD.ClassID = CT.ClassID AND SD.EquipID = CT.EquipID
JOIN Class C ON CT.ClassID = C.ClassID
JOIN Equipment E ON CT.EquipID = E.EquipID
JOIN EndData ED ON SD.RoundID = ED.RoundID AND SD.RangeID = ED.RangeID AND SD.EndID = ED.EndID
JOIN RoundData RD ON SD.RoundID = RD.RoundID AND SD.RangeID = RD.RangeID
WHERE 
    SD.ArcherID = 'A1'
    AND SD.DateInfo BETWEEN '2020-01-01' AND '2030-12-31'
    AND RD.RoundType = 'Pro'
GROUP BY SD.ArcherID, AD.ArcName, RD.RoundType, E.EquipDesc, C.ClassDesc, SD.DateInfo, ED.Arrow1, ED.Arrow2, ED.Arrow3, ED.Arrow4, ED.Arrow5, ED.Arrow6, RD.PossibleScore
ORDER BY SD.DateInfo DESC, TotalScore DESC;