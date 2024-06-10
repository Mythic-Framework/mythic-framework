local _ran = false

function AddDefaultData()
    if not _ran then
        _ran = true
        Default:Add(
            "mdt_charges",
            1630665654,
            json.decode([[
                [
                    {
                        "title": "Capital Murder",
                        "type": 3,
                        "jail": 999,
                        "fine": 0,
                        "description": "1st Degree Murder with specific circumstances. The special circumstances are defined as such:- Killing a government employee;- Killing an active member of a jury;- Killing a witness to prevent testimony in court;- Killing more than one victim (serial);",
                        "points": 0
                    },
                    {
                        "title": " Accessory to Capital Murder",
                        "type": 3,
                        "jail": 999,
                        "fine": 0,
                        "description": "Accessory to Capital Murder",
                        "points": 0
                    },
                    {
                        "title": "1st Degree Murder",
                        "type": 3,
                        "jail": 999,
                        "fine": 0,
                        "description": "The unlawful killing of another human without justification or valid excuse, with malice aforethought/premeditation.",
                        "points": 0
                    },
                    {
                        "title": "Accessory to 1st Degree Murder",
                        "type": 3,
                        "jail": 999,
                        "fine": 0,
                        "description": "Aids and or Abets the unlawful killing of another human without justification or valid excuse, especially the unlawful killing of another human with malice aforethought / premeditation.",
                        "points": 0
                    },
                    {
                        "title": "Attempted 1st Degree Murder",
                        "type": 3,
                        "jail": 85,
                        "fine": 5000,
                        "description": "The attempt to unlawfully kill another human without justification or valid excuse, with malice aforethought/premeditation.",
                        "points": 0
                    },
                    {
                        "title": "2nd Degree Murder",
                        "type": 3,
                        "jail": 350,
                        "fine": 30000,
                        "description": "The act of unlawfully killing that doesn’t involve malice aforethought—intent to seriously harm or kill, or extreme, reckless disregard for life. Heat of passion, callous disregard for human life.",
                        "points": 0
                    },
                    {
                        "title": "Accessory to 2nd Degree Murder",
                        "type": 3,
                        "jail": 300,
                        "description": "Aids and or Abets the unlawfully killing that doesn’t involve malice aforethought—intent to seriously harm or kill, or extreme, reckless disregard for life. Heat of passion, callous disregard for human life.",
                        "points": 0
                    },
                    {
                        "title": "Attempted 2nd Degree Murder",
                        "type": 3,
                        "jail": 65,
                        "fine": 3000,
                        "description": "The attempt to unlawfully kill that doesn’t involve malice aforethought—intent to seriously harm or kill, or extreme, reckless disregard for life. Heat of passion, callous disregard for human life.",
                        "points": 0
                    },
                    {
                        "title": "Voluntary Manslaughter",
                        "type": 3,
                        "jail": 130,
                        "fine": 17500,
                        "description": "The accidental, criminally negligent, or criminally reckless killing of another individual with the intent to physically harm them. ",
                        "points": 0
                    },
                    {
                        "title": "Vehiclular Manslaughter",
                        "type": 3,
                        "jail": 115,
                        "fine": 16000,
                        "description": "The accidental, criminally negligent, or criminally reckless killing of another individual whilst driving a motor vehicle. ",
                        "points": 0
                    },
                    {
                        "title": "Involuntary Manslaughter",
                        "type": 3,
                        "jail": 100,
                        "fine": 15000,
                        "description": "The accidental, criminally negligent, or criminally reckless killing of another individual with no intent to physically harm them. ",
                        "points": 0
                    },
                    {
                        "title": "Gang Related Shooting",
                        "type": 3,
                        "jail": 75,
                        "fine": 7500,
                        "description": "Any individual who, with one or more members of their “gang” engages in a shooting/shootout with two or more members of other gangs. A “gang” is defined as an ongoing group, club, organization, or association of three or more persons which has the primary purpose of the commission of criminal offenses, or the members of which over the last ninety days have engaged in continuing or ongoing series of felony offenses. Alternatively, any individual or individuals flagged as “gang related” based on knowledge or probable cause by Law Enforcement. ",
                        "points": 0
                    },
                    {
                        "title": "Kidnapping a Government Employee",
                        "type": 3,
                        "jail": 30,
                        "fine": 5000,
                        "description": "Abducts a government employee and holds them against their will.",
                        "points": 0
                    },
                    {
                        "title": "Kidnapping",
                        "type": 3,
                        "jail": 20,
                        "fine": 1800,
                        "description": "Abducts another person and holds them against their will.",
                        "points": 0
                    },
                    {
                        "title": "Assault with a Deadly Weapon",
                        "type": 3,
                        "jail": 25,
                        "fine": 1575,
                        "description": "Attempts to commit a violent injury upon another person with a deadly weapon. A weapon is descibed as a firearm or any type of melee item, also including motor vehicles.",
                        "points": 0
                    },
                    {
                        "title": "Reckless Endangerment ",
                        "type": 3,
                        "jail": 15,
                        "fine": 950,
                        "description": "Person creates a substantial risk of serious physical injury to themselves or another person. The accused person isn't required to intend the resulting or potential harm, but must have acted in a way that showed a disregard for the foreseeable consequences of the actions.",
                        "points": 0
                    },
                    {
                        "title": "Unlawful Imprisonment",
                        "type": 2,
                        "jail": 15,
                        "fine": 825,
                        "description": "Restricts a person's movement within any area without justification or consent.",
                        "points": 0
                    },
                    {
                        "title": "Criminal Threats",
                        "type": 2,
                        "jail": 15,
                        "fine": 1050,
                        "description": "A \"criminal threat\" is when you threaten to kill or physically harm someone.That person is thereby placed in a state of reasonably sustained fear for his/her safety or for the safety of his/her immediate family, the threat is specific and unequivocal and you communicate the threat verbally, in writing, or via an electronically transmitted device.",
                        "points": 0
                    },
                    {
                        "title": "Assault & Battery",
                        "type": 2,
                        "jail": 15,
                        "fine": 825,
                        "description": "Openly threatens violence or injury upon an individual either orally or thru their actions and acts upon that threat.",
                        "points": 0
                    },
                    {
                        "title": "Terrorism ",
                        "type": 3,
                        "jail": 999,
                        "fine": 0,
                        "description": "The unlawful use of Extreme Violence and Intimidation against the Civilian Population that would pursue political aims, compromise medical neutrality, or in the name of religious ideology. The unlawful use of Extreme Violence and Intimidation against Government Entities that would pursue the disruption, destabilization or destruction of those entities for political or religious aims.",
                        "points": 0
                    },
                    {
                        "title": "Weapons Trafficking",
                        "type": 3,
                        "jail": 999,
                        "fine": 0,
                        "description": "The unlawful transportation of a large quantity of any class of firearms and/or molotov cocktails and/or explosives, with the intent to distribute. Intent to distribute can be inferred through circumstances surrounding the discovery of the firearms or a pattern of behavior of the suspects, including large sums of money, and/or the possession of six or more firearms.",
                        "points": 0
                    },
                    {
                        "title": "Criminal Possession of a Government-Issue Firearm",
                        "type": 3,
                        "jail": 210,
                        "fine": 22500,
                        "description": "It is illegal to possess a government-owned or issued firearm, without being a duly sworn Peace Officer. This also includes flashbangs.",
                        "points": 0
                    },
                    {
                        "title": "Criminal Possession of a Government-Issue Less Lethal Firearm/Weapon",
                        "type": 3,
                        "jail": 70,
                        "fine": 12000,
                        "description": "It is illegal to possess a government-owned or issued less-lethal firearm, without being a duly sworn Peace Officer. This would include tasers, batons and beanbag shotguns.",
                        "points": 0
                    },
                    {
                        "title": "Criminal Possession of a Firearm [Class 3]",
                        "type": 3,
                        "jail": 35,
                        "fine": 2625,
                        "description": "Possesses a Class 3 weapon. LMG, RPG, DMR's",
                        "points": 0
                    },
                    {
                        "title": "Criminal Possession of a Firearm [Class 2]",
                        "type": 3,
                        "jail": 28,
                        "fine": 2100,
                        "description": "Possess a Class 2 weapon. Possesses semi-automatic to automatic firearms, and shotguns.",
                        "points": 0
                    },
                    {
                        "title": "Criminal Possession of a Firearm [Class 1]",
                        "type": 2,
                        "jail": 10,
                        "fine": 525,
                        "description": "Possess a Class 1 weapon without a proper license or a weapon which is not registered to the individual possessing it.",
                        "points": 0
                    },
                    {
                        "title": "Criminal Sale of a Firearm [Class 2 and 3]",
                        "type": 3,
                        "jail": 35,
                        "fine": 2625,
                        "description": "The unlawful sale of a Class 2 or Class 3 weapon",
                        "points": 0
                    },
                    {
                        "title": "Criminal Sale of a Firearm [Class 1]",
                        "type": 3,
                        "jail": 12,
                        "fine": 900,
                        "description": "The unlawful sale, or purchase, of a Class 1 firearm, when a person does not own a proper weapon license.",
                        "points": 0
                    },
                    {
                        "title": "Possession of Explosives",
                        "type": 3,
                        "jail": 100,
                        "fine": 5000,
                        "description": "Possesses explosives on his or her person. Includes transport of explosives.",
                        "points": 0
                    },
                    {
                        "title": "Criminal Use of Explosives",
                        "type": 3,
                        "jail": 35,
                        "fine": 2625,
                        "description": "A person is guilty of criminal use of explosives if they intentionally place, use, or attempt to use explosives against any real person or property and detonate said explosives, directly or indirectly. This shall include the use of tanker trucks, cars ignited in gasoline, or tanks/barrels full of combustible liquid for the purpose of causing an explosion. This charge may be issued in addition to Attempted Murder.",
                        "points": 0
                    },
                    {
                        "title": "Criminal Possession of a Government Issued Equipment",
                        "type": 3,
                        "jail": 20,
                        "fine": 1125,
                        "description": "It is illegal to possess a government-owned or issued equipment (non weapons) without being a government employee with the right to possess them.",
                        "points": 0
                    },
                    {
                        "title": "Possession of a Molotov",
                        "type": 3,
                        "jail": 30,
                        "fine": 2625,
                        "description": "Person possesses a molotov or other improvised incendiary weapons.",
                        "points": 0
                    },
                    {
                        "title": "Possession of a Silencer / Suppressor",
                        "type": 3,
                        "jail": 25,
                        "fine": 1000,
                        "description": "It is illegal to possess a silencer/suppressor. No person shall possess any type of device that alters the sound of a firearm.",
                        "points": 0
                    },
                    {
                        "title": "Resisting Arrest",
                        "type": 2,
                        "jail": 10,
                        "fine": 525,
                        "description": "Flees from a Law Enforcement Officer to avoid being apprehended, detained, or arrested while on foot, or a passenger in a vehicle.",
                        "points": 0
                    },
                    {
                        "title": "Criminal Use of a Firearm",
                        "type": 2,
                        "jail": 15,
                        "fine": 525,
                        "description": "Discharges a firearm for no legal reason, or using a firearm in the commission to aid in a crime.",
                        "points": 0
                    },
                    {
                        "title": "Brandishing of a Firearm",
                        "type": 2,
                        "jail": 10,
                        "fine": 525,
                        "description": "Displaying a firearm in public without a legal reason. \"Open Carry\" is not a legal reason to have a weapon in your hand. To open carry, the weapon must be holstered or attached to a sling. ",
                        "points": 0
                    },
                    {
                        "title": "Brandishing of a non Firearm",
                        "type": 2,
                        "jail": 8,
                        "fine": 375,
                        "description": "It is unlawful for you to draw or exhibit a potentially deadly weapon in a rude, angry, or threatening way in the presence of another person and not in defense of self or others",
                        "points": 0
                    },
                    {
                        "title": "Jaywalking",
                        "type": 1,
                        "jail": 0,
                        "fine": 150,
                        "description": "Crosses a road without the use of a crosswalk, or without a marked crossing light.",
                        "points": 0
                    },
                    {
                        "title": "Aggravated Robbery",
                        "type": 3,
                        "jail": 35,
                        "fine": 2250,
                        "description": "A robbery in which the victim, a hostage, or a third party otherwise uninvolved in the crime is physically injured. ",
                        "points": 0
                    },
                    {
                        "title": "Accessory to Aggravated Robbery",
                        "type": 3,
                        "jail": 30,
                        "fine": 1500,
                        "description": "Harboring, concealing or aiding a person in the act/attempt to commit Aggravated Robbery.",
                        "points": 0
                    },
                    {
                        "title": "Robbery",
                        "type": 3,
                        "jail": 25,
                        "fine": 1875,
                        "description": "The taking or carrying away with the intent to steal any thing of value in the care, custody, control, management, or possession of any store, bank, or financial institution, including but not limited to all Fleeca Banks, 24/7 Gas Stations, LTD Gas Stations, or Vangelico’s Jewelry Stores. Alternatively, the taking or carrying away with the intent to steal any thing of value from the direct custody of another person.",
                        "points": 0
                    },
                    {
                        "title": "Accessory to Robbery",
                        "type": 3,
                        "jail": 20,
                        "fine": 1050,
                        "description": "Harboring, concealing or aiding a person in the act/attempt to commit Robbery.",
                        "points": 0
                    },
                    {
                        "title": "First Degree Money Laundering",
                        "type": 3,
                        "jail": 35,
                        "fine": 5000,
                        "description": "Possesses money in the amount of $30,000 or more with the specific intent to use it to promote criminal activity or the knowledge that the money involved came from criminal activity.",
                        "points": 0
                    },
                    {
                        "title": "Second Degree Money Laundering",
                        "type": 3,
                        "jail": 20,
                        "fine": 2500,
                        "description": "Possesses money in the amount of $10,000 or more with the specific intent to use it to promote criminal activity or the knowledge that the money involved came from criminal activity.",
                        "points": 0
                    },
                    {
                        "title": "Third Degree Money Laundering",
                        "type": 2,
                        "jail": 15,
                        "fine": 1500,
                        "description": "Possesses money in the amount of less than $10,000 with the specific intent to use it to promote criminal activity or the knowledge that the money involved came from criminal activity.",
                        "points": 0
                    },
                    {
                        "title": "Sale of Stolen Goods or Stolen Property",
                        "type": 2,
                        "jail": 22,
                        "fine": 1650,
                        "description": "The bartering or selling of wares, merchandise, or property that has been stolen from another and the person knew or has reason to know the property was stolen. Color coded bank cards are per se considered to be stolen goods or property under this statute. ",
                        "points": 0
                    },
                    {
                        "title": "Receiving Stolen Property in the First Degree",
                        "type": 3,
                        "jail": 14,
                        "fine": 1050,
                        "description": "A person who bought, received, sold or participated in selling, concealed or withheld property that has been stolen from another, and the individual knew the property was stolen.  To include possession of color coded bank cards in the amount of 11 or more.",
                        "points": 0
                    },
                    {
                        "title": "Receiving Stolen Property in the Second Degree",
                        "type": 2,
                        "jail": 12,
                        "fine": 900,
                        "description": "A person who bought, received, sold or participated in selling, concealed or withheld property that has been stolen from another, and the individual knew the property was stolen. To included color coded bank cards in the amount of 6 to 10",
                        "points": 0
                    },
                    {
                        "title": "Receiving Stolen Property in the Third Degree",
                        "type": 2,
                        "jail": 7,
                        "fine": 525,
                        "description": "A person who bought, received, sold or participated in selling, concealed or withheld property that has been stolen from another, and the individual knew the property was stolen. To included color coded bank cards in the amount of 5 or less.",
                        "points": 0
                    },
                    {
                        "title": "Possession of Stolen Goods",
                        "type": 3,
                        "jail": 14,
                        "fine": 1050,
                        "description": "Possesion of Valuable Goods without proof of ownership.",
                        "points": 0
                    },
                    {
                        "title": "Possession of a Stolen Identification ",
                        "type": 2,
                        "jail": 12,
                        "fine": 900,
                        "description": "Possesses the Identification Card of another citizen without consent.",
                        "points": 0
                    },
                    {
                        "title": "Leaving Without Paying",
                        "type": 2,
                        "jail": 12,
                        "fine": 900,
                        "description": "It is illegal for a person to obtain services by deception, force, threat or other unlawful means, or without lawfully compensating the provider for these services provided. This will include garages and restaurants.",
                        "points": 0
                    },
                    {
                        "title": "Grand Theft Auto",
                        "type": 3,
                        "jail": 14,
                        "fine": 1050,
                        "description": "Unlawfully taking a vehicle belonging to another, or driving the vehicle without the owner's consent, with the intent to permanently deprive the owner of the vehicle.",
                        "points": 0
                    },
                    {
                        "title": "Joyriding",
                        "type": 2,
                        "jail": 7,
                        "fine": 525,
                        "description": "The taking or operating of a vehicle without the owner's consent, without the intent to deprive the owner of the vehicle permanently.",
                        "points": 0
                    },
                    {
                        "title": "Tampering with a Vehicle",
                        "type": 2,
                        "jail": 7,
                        "fine": 525,
                        "description": "No person shall either individually or in association with one or more other persons, willfully tamper with any vehicle or the contents thereof, or break or remove any part of a vehicle without the consent of the owner.",
                        "points": 0
                    },
                    {
                        "title": "Grand Theft",
                        "type": 2,
                        "jail": 10,
                        "fine": 1500,
                        "description": "Steals property in the value of $1,000 or more from another person.",
                        "points": 0
                    },
                    {
                        "title": "Petty Theft",
                        "type": 2,
                        "jail": 7,
                        "fine": 500,
                        "description": "Steals property in the value of less than $1,000 from another person.",
                        "points": 0
                    },
                    {
                        "title": "Arson",
                        "type": 3,
                        "jail": 25,
                        "fine": 1650,
                        "description": "Person maliciously sets fire to a structure, forest land, or other property. To include the use of thermite at banks, vaults, or other locations.",
                        "points": 0
                    },
                    {
                        "title": "Felony Trespassing",
                        "type": 3,
                        "jail": 15,
                        "fine": 1500,
                        "description": "Enters knowingly or remains unlawfully in or upon a government property without permission or the right to do so. Includes power plants.",
                        "points": 0
                    },
                    {
                        "title": "Burglary",
                        "type": 3,
                        "jail": 15,
                        "fine": 900,
                        "description": "Any person who breaks and enters any property or attempts to break and enter into a property with the intent either to commit theft or to commit any misdemeanor or felony within.",
                        "points": 0
                    },
                    {
                        "title": "Trespassing",
                        "type": 2,
                        "jail": 10,
                        "fine": 500,
                        "description": "Enters knowingly or remains unlawfully upon a property without the permission or the right to do so.",
                        "points": 0
                    },
                    {
                        "title": "Contempt of Court",
                        "type": 2,
                        "jail": 999,
                        "fine": 0,
                        "description": "The act of being disobedient to or discourteous towards a court of law and its officers in the form of behavior that opposes or defies the authority, justice and dignity of the court. Time/Fine is at Judge discretion.",
                        "points": 0
                    },
                    {
                        "title": "Failure to Appear",
                        "type": 2,
                        "jail": 999,
                        "fine": 0,
                        "description": "Failure to appear in Court when summoned.",
                        "points": 0
                    },
                    {
                        "title": "Perjury",
                        "type": 3,
                        "jail": 999,
                        "fine": 0,
                        "description": "Knowingly lies under oath in judicial proceedings.",
                        "points": 0
                    },
                    {
                        "title": "Witness Tampering",
                        "type": 3,
                        "jail": 999,
                        "fine": 0,
                        "description": "The use of physical force, threat of physical force, use of intimidation, or use of threats in an attempt to hinder, delay, or prevent, an individual from producing testimony or evidence before the court or an attempt to alter or destroy the evidence or testimony to be produced. ",
                        "points": 0
                    },
                    {
                        "title": "Prison Break",
                        "type": 3,
                        "jail": 75,
                        "fine": 4000,
                        "description": "Breaks into government buildings, vehicles designated for detainment, or imprisonment with intent to break a prisoner out. Steals a law enforcement vehicle intending to transport an individual/individuals to prison after processing has occurred. Includes the act of an inmate or suspect leaving prison through unofficial or illegal ways.",
                        "points": 0
                    },
                    {
                        "title": "Attempted Prison Break",
                        "type": 3,
                        "jail": 40,
                        "fine": 2500,
                        "description": "Aids in the act of, or attempt to break an individual out of prison, or prison transport after processing has occurred.",
                        "points": 0
                    },
                    {
                        "title": "Harboring or Aiding an Escaped Violent Felon",
                        "type": 3,
                        "jail": 65,
                        "fine": 3000,
                        "description": "Whoever knowingly harbors or conceals any prisoner wanted for a capital level offense after their escape from custody of Bolingbroke State Penitentiary or any other State correctional institution shall be guilty of this offense. This offense shall include but not be limited to providing residence for the prisoner, assisting the prisoner in escape from the authorities, and/or failing to notify the proper authorities of the prisoner's location if the suspect should reasonably know the prisoner is wanted for arrest on capital level offenses. ",
                        "points": 0
                    },
                    {
                        "title": "Introducing Contraband Into a Government Facility",
                        "type": 3,
                        "jail": 20,
                        "fine": 1500,
                        "description": "It is unlawful to introduce contraband into or upon the grounds of Bolingbroke State Penitentiary or any other State correctional institution shall be guilty of this offense.Contraband is described as any controlled substance, intoxicating beverage, weapon, explosive, radio, telephone or any writing or recording device to be used to transmit information.",
                        "points": 0
                    },
                    {
                        "title": "Violating a Court Order",
                        "type": 3,
                        "jail": 30,
                        "fine": 2000,
                        "description": "Willful disobedience of the terms written in a court order. To include a sentence imposed on a citizen, protective, and restraining orders.",
                        "points": 0
                    },
                    {
                        "title": "Embezzlement ",
                        "type": 3,
                        "jail": 25,
                        "fine": 525,
                        "description": "Steals or misappropriates funds or property that has been entrusted in you with the intent of depriving the rightful owner.",
                        "points": 0
                    },
                    {
                        "title": "Bribery",
                        "type": 3,
                        "jail": 20,
                        "fine": 1900,
                        "description": "The offering, giving or recieving of anything of value in exchange for the recipient to perform an act such as a favour. The bribe can consist of anything that the recipient may view as valuable like cash or personal favours. This charge includes the recipient of a bribe.",
                        "points": 0
                    },
                    {
                        "title": "Escaping Custody",
                        "type": 3,
                        "jail": 14,
                        "fine": 1575,
                        "description": "Escapes the custody of law enforcement once that person has been, detained/arrested but before processing occurs.",
                        "points": 0
                    },
                    {
                        "title": "Accessory to Escaping Custody",
                        "type": 3,
                        "jail": 14,
                        "fine": 1050,
                        "description": "Person aids or assists, another citizen in escaping the custody of law enforcement once that person has been, detained/arrested but before processing occurs.",
                        "points": 0
                    },
                    {
                        "title": "Parole Violation ",
                        "type": 3,
                        "jail": 10,
                        "fine": 1000,
                        "description": "Person who violates their parole time, set by their previous arrest.",
                        "points": 0
                    },
                    {
                        "title": "Conspiracy",
                        "type": 2,
                        "jail": 10,
                        "fine": 800,
                        "description": "Conspires to commit a crime.",
                        "points": 0
                    },
                    {
                        "title": "Unauthorized Practice of Law",
                        "type": 2,
                        "jail": 8,
                        "fine": 500,
                        "description": "Practices law without a proper Bar certification.",
                        "points": 0
                    },
                    {
                        "title": "Misuse of a 911 System",
                        "type": 2,
                        "jail": 5,
                        "fine": 1000,
                        "description": "Person makes a request for emergency response when no actual emergency exists, and when the caller does not have a good faith basis to request emergency assistance.",
                        "points": 0
                    },
                    {
                        "title": "Human Trafficking",
                        "type": 3,
                        "jail": 999,
                        "fine": 0,
                        "description": "The unlawful act of forcefully transporting or coercing individuals into preforming an act or service, being that of forced labor or otherwise, without that indviduals consent. ",
                        "points": 0
                    },
                    {
                        "title": "Drug Trafficking",
                        "type": 3,
                        "jail": 999,
                        "fine": 0,
                        "description": "Any person who is found guilty of Felony Possession with Intent to Distribute and which meets one or more of the following requirements: (1) The suspect shows a pattern of drug distribution or felony possession of controlled dangerous substances, demonstrable through three or more provable instances;(2) Proof or evidence that the suspect has manufactured or cultivated a controlled dangerous substance;",
                        "points": 0
                    },
                    {
                        "title": "Felony Possession with intent to Distribute",
                        "type": 3,
                        "jail": 150,
                        "fine": 12250,
                        "description": "Any person who is found to have large quantities of drugs on their person, vehicle, and or property with intent to distribute. Intent to distribute can be inferred through circumstances surrounding the discovery of the drugs or a pattern of behavior of the suspect such as large sums of money, high-grade weaponry, or other paraphernalia used in the measuring/weighing or breaking down of large quantities to smaller quantities",
                        "points": 0
                    },
                    {
                        "title": "Sale of Drugs",
                        "type": 3,
                        "jail": 35,
                        "fine": 2500,
                        "description": "Sale of a controlled substance or controlled dangerous substance.",
                        "points": 0
                    },
                    {
                        "title": "Felony Possession of a Controlled Dangerous Substance",
                        "type": 3,
                        "jail": 30,
                        "fine": 1875,
                        "description": "Possesses a controlled dangerous substance. 27+ units of OXY. Possesses methamphetamine. 20+ units of methamphetamine.",
                        "points": 0
                    },
                    {
                        "title": "Felony Possession of a Controlled Substance",
                        "type": 3,
                        "jail": 25,
                        "fine": 1875,
                        "description": "Possesses 50+ grams (10 bags @ 5g per bag) of Crack Cocaine.Possessing 50+ grams (10 bags @ 5g per bag) of Cocaine.Possesses 10 or more LSD tabs.Possesses any amount of marijuana greater than 15 lbs, or greater than 25 joints.",
                        "points": 0
                    },
                    {
                        "title": "Cultivation of Marijuana",
                        "type": 3,
                        "jail": 25,
                        "fine": 1875,
                        "description": "Person possesses 3 or more marijuana plants in a single location.",
                        "points": 0
                    },
                    {
                        "title": "Misdemeanor Possession of Controlled Dangerous Substance",
                        "type": 2,
                        "jail": 15,
                        "fine": 1000,
                        "description": "Possesses a controlled dangerous substance. 5+ units of Oxy. Possesses methamphetamine.",
                        "points": 0
                    },
                    {
                        "title": "Misdemeanor Possession of a Controlled Substance",
                        "type": 2,
                        "jail": 10,
                        "fine": 725,
                        "description": "Possesses up to 50 grams (10 bags @ 5g per bag) of Crack Cocaine.Possesses up to 50 grams (10 bags @ 5g per bag) of Cocaine.Possesses less than 10 LSD tabs.Possesses any amount of marijuana greater than 5 lbs, or greater than 9 joints.",
                        "points": 0
                    },
                    {
                        "title": "Possession of Drug Paraphernalia ",
                        "type": 2,
                        "jail": 5,
                        "fine": 450,
                        "description": "Any item that is used in the manufacturing, production, distribution, sale, or consumption of drugs. This is to include marijuana seeds, and scales that are used to weigh drugs.",
                        "points": 0
                    },
                    {
                        "title": "Desecration of a Human Corpse",
                        "type": 3,
                        "jail": 20,
                        "fine": 1350,
                        "description": "Desecration of a human corpse means any act committed after the death of a human being including, but not limited to, dismemberment, disfigurement, mutilation, burning, or any act committed to cause the dead body to be devoured, scattered or dissipated; except, those procedures performed by a state agency or licensed authority in due course of its duties and responsibilities. This includes the removal of a corpse from the custody of the morgue.",
                        "points": 0
                    },
                    {
                        "title": "Illegal Exhumation",
                        "type": 3,
                        "jail": 15,
                        "fine": 1000,
                        "description": "The removal of a body without authorization from where it lies in state, or it's final resting place.",
                        "points": 0
                    },
                    {
                        "title": "Practicing Medicine Without a License",
                        "type": 2,
                        "jail": 12,
                        "fine": 1125,
                        "description": "Practicing medicine without a proper license. Treating citizens for any medical, or health related issue without proper documentation or licensing. Law Enforcement is exempt only during their qualified duties. ",
                        "points": 0
                    },
                    {
                        "title": "Public Indecency",
                        "type": 2,
                        "jail": 7,
                        "fine": 525,
                        "description": "A lewd caress or indecent fondling of the body. Public place shall also include jails, and correctional institutions of the state.",
                        "points": 0
                    },
                    {
                        "title": "Littering",
                        "type": 1,
                        "jail": 0,
                        "fine": 250,
                        "description": "The act of throwing objects on the ground in a disobedient manner. Leaving trash and other items on the ground.",
                        "points": 0
                    },
                    {
                        "title": "Public Intoxication ",
                        "type": 1,
                        "jail": 0,
                        "fine": 150,
                        "description": "A person who is under the influence of Alcohol or a Controlled Dangerous Substance, in a public place.",
                        "points": 0
                    },
                    {
                        "title": "Impersonating a Judge",
                        "type": 3,
                        "jail": 40,
                        "fine": 4500,
                        "description": "Acting as a Judge or introducing themselves to others a judge and attempting to perform judicial duties",
                        "points": 0
                    },
                    {
                        "title": "Impersonating a Government Employee",
                        "type": 3,
                        "jail": 30,
                        "fine": 3000,
                        "description": "Acting as public servant or introducing themselves to others as a public servant, and attempting to perform their duties. This includes public servants and all other government employees that are not otherwise listed under a higher impersonation charge.",
                        "points": 0
                    },
                    {
                        "title": "Impersonation",
                        "type": 3,
                        "jail": 15,
                        "fine": 1100,
                        "description": "Providing law enforcement with a false, or fictitious name, while under detainment or under arrest.",
                        "points": 0
                    },
                    {
                        "title": "Identity Theft",
                        "type": 3,
                        "jail": 20,
                        "fine": 1575,
                        "description": "A person secures an undeserved financial benefit for themselves. Cause the victim to suffer a loss, which could be financial, emotional or some other type of damage. Escapes criminal liability by using another person's name, birth date or other identifying information.",
                        "points": 0
                    },
                    {
                        "title": "Vehicle Registration Fraud",
                        "type": 3,
                        "jail": 20,
                        "fine": 1575,
                        "description": "Person(s) possesses or displays a falsified license plate on a motor vehicle. Person(s) manufactures a falsified license plates.",
                        "points": 0
                    },
                    {
                        "title": "Extortion",
                        "type": 3,
                        "jail": 15,
                        "fine": 1050,
                        "description": "The use of force or threats to compel another person to relinquish money or property or to compel a public officer or State employee to perform an official act within the course and scope of their employment. ",
                        "points": 0
                    },
                    {
                        "title": "Fraud",
                        "type": 3,
                        "jail": 10,
                        "fine": 1050,
                        "description": "Wrongfully deceits intending to receive financial or personal gain.",
                        "points": 0
                    },
                    {
                        "title": "Disruption of a Public Utility",
                        "type": 3,
                        "jail": 35,
                        "fine": 5000,
                        "description": "Disruption of a Public Utility - The attempt, or successful execution of the disruption of any electrical power grid.",
                        "points": 0
                    },
                    {
                        "title": "Inciting a Riot",
                        "type": 3,
                        "jail": 30,
                        "fine": 4000,
                        "description": "Organizes an event/assembly which results in violent conduct or creates a risk of causing public harm with a group of at least four people.",
                        "points": 0
                    },
                    {
                        "title": "Felony Obstruction of Justice",
                        "type": 3,
                        "jail": 25,
                        "fine": 1800,
                        "description": "Intentionally hinders the discovery, apprehension, conviction, or punishment of a person who committed a crime, including intentionally involving oneself in an ongoing criminal act or investigation in such a way that peace officers are impeded from administering justice.",
                        "points": 0
                    },
                    {
                        "title": "Misdemeanor Obstruction of Justice",
                        "type": 2,
                        "jail": 18,
                        "fine": 900,
                        "description": "Recklessly or with criminal negligence hinders the discovery, apprehension, conviction, or punishment of a person who committed a crime, including issuing threats of violence, impeding the administration of justice, or withholding of non-privileged information or evidence from peace officers.",
                        "points": 0
                    },
                    {
                        "title": "Planting or Tampering of Evidence",
                        "type": 2,
                        "jail": 15,
                        "fine": 600,
                        "description": "Destroy, plant, conceal, or remove a piece of evidence with the purpose of hiding the truth, altering the truth or make an item unavailable for proceeding investigation.",
                        "points": 0
                    },
                    {
                        "title": "Disobeying a Peace Officer ",
                        "type": 2,
                        "jail": 12,
                        "fine": 525,
                        "description": "Willfully refusing or failing to comply with a lawful order, signal, or direction of any peace officer.",
                        "points": 0
                    },
                    {
                        "title": "Disorderly Conduct",
                        "type": 2,
                        "jail": 10,
                        "fine": 375,
                        "description": "Engages in behavior intending to cause public inconvenience.",
                        "points": 0
                    },
                    {
                        "title": "Harassment",
                        "type": 2,
                        "jail": 7,
                        "fine": 525,
                        "description": "Intimidates or pressures another person aggressively with unwelcome words, deeds, actions, or gestures.",
                        "points": 0
                    },
                    {
                        "title": "False Reporting",
                        "type": 2,
                        "jail": 7,
                        "fine": 525,
                        "description": "Reports a false or non-existent crime.",
                        "points": 0
                    },
                    {
                        "title": "Poaching",
                        "type": 3,
                        "jail": 15,
                        "fine": 1500,
                        "description": "No person shall either individually or in association with one or more other persons, bait, trap, hunt injure, maim, kill, otherwise harm, or maintain possession of the pelt, carcass, or any other part of an a wild animal without the correct license to hunt such animal or the animal is defined as being protected by the DOJ.",
                        "points": 0
                    },
                    {
                        "title": "Animal Cruelty",
                        "type": 2,
                        "jail": 7,
                        "fine": 525,
                        "description": "Maliciously and intentionally wounds or kills an animal.",
                        "points": 0
                    },
                    {
                        "title": "Stalking",
                        "type": 2,
                        "jail": 7,
                        "fine": 250,
                        "description": "The following, harassing, threatening of another person, to the point where an individual fears for his/her safety.",
                        "points": 0
                    },
                    {
                        "title": "Disturbing the Peace",
                        "type": 2,
                        "jail": 5,
                        "fine": 375,
                        "description": "Unlawfully fighting, or challenging another person to fight, in a public place. Disturbing another person by loud and unreasonable noise; if this is done willfully and maliciously. Using offensive words in a public place, if the words are likely to provoke an immediate violent reaction.",
                        "points": 0
                    },
                    {
                        "title": "Vandalism of Government Property",
                        "type": 2,
                        "jail": 5,
                        "fine": 375,
                        "description": "Intentionally causing damage to Government Property.",
                        "points": 0
                    },
                    {
                        "title": "Vandalism",
                        "type": 1,
                        "jail": 0,
                        "fine": 250,
                        "description": "Intentionally causing damage to property they do not own.",
                        "points": 0
                    },
                    {
                        "title": "Loitering",
                        "type": 1,
                        "jail": 0,
                        "fine": 200,
                        "description": "Intentionally standing or waiting idly without apparent purpose.",
                        "points": 0
                    },
                    {
                        "title": "Piloting Without a Proper License",
                        "type": 3,
                        "jail": 40,
                        "fine": 3500,
                        "description": "Operating (or attempting to operate) an aircraft without the proper license. This includes, Helicopters, and Fixed Wing Aircraft.",
                        "points": 0
                    },
                    {
                        "title": "Flying into Restricted Airspace",
                        "type": 3,
                        "jail": 30,
                        "fine": 2500,
                        "description": "The unauthorized flight into, or landing in restricted airspace. The restricted areas are as follows. Aircraft carrier, any and all power plants. This includes landing on Pillbox Medical Center, and any Government building or property without permission to do so. Certified pilots will lose their license for any of of the above listed. Law Enforcement and EMS are exempt.",
                        "points": 0
                    },
                    {
                        "title": "Street Racing",
                        "type": 3,
                        "jail": 25,
                        "fine": 1575,
                        "description": "A person shall not engage (organize or partake) in a street race on a highway or public roadway of any kind whether it be as a sport of for material gain.A street race can be against another vehicle or any kind of timing device.Adds 4 points on License.",
                        "points": 4
                    },
                    {
                        "title": "Reckless Evading",
                        "type": 3,
                        "jail": 20,
                        "fine": 1350,
                        "description": "Dangerously flees from law enforcement while operating a motor vehicle to avoid being apprehended, detained, or arrested. Crossing into oncoming lanes of traffic, causing damage to property, putting lives in danger.",
                        "points": 0
                    },
                    {
                        "title": "Operating a Motor Vehicle on a Suspended or Revoked License",
                        "type": 3,
                        "jail": 15,
                        "fine": 1050,
                        "description": "Person operates a motor vehicle on a suspended and revoked license. Vehicle is to be Impounded, and the operator of the vehicle arrested for not having the proper license to drive legally.",
                        "points": 0
                    },
                    {
                        "title": "Felony Hit and Run",
                        "type": 3,
                        "jail": 15,
                        "fine": 1050,
                        "description": "Leaving a scene of an accident that resulted in injury to others, without identifying yourself to the parties involved.",
                        "points": 0
                    },
                    {
                        "title": "Reckless Driving",
                        "type": 3,
                        "jail": 12,
                        "fine": 900,
                        "description": "Drives in a way that is careless and with gross disregard for human life.",
                        "points": 0
                    },
                    {
                        "title": "Unauthorized Operation of an Off-Road Vehicle",
                        "type": 2,
                        "jail": 10,
                        "fine": 750,
                        "description": "It is unlawful to operate an off-road, or off highway vehicle on city streets, highways, county roads, and sidewalks. Off-road vehicles are classified as ATV's, Dirt Bikes, Farm Tractors, Golf Carts, and Dune Buggies that don't have a visible license plate displayed. Law enforcement may use discretion if the person is transporting from a car dealership after purchase.",
                        "points": 0
                    },
                    {
                        "title": "Misdemeanor Hit and Run",
                        "type": 2,
                        "jail": 10,
                        "fine": 525,
                        "description": "Leaving a scene of an accident with property damage, without identifying yourself to the parties involved.",
                        "points": 0
                    },
                    {
                        "title": "Evading",
                        "type": 2,
                        "jail": 7,
                        "fine": 525,
                        "description": "Flees from law enforcement in a vehicle to avoid being apprehended, detained, or arrested.",
                        "points": 0
                    },
                    {
                        "title": "Driving While Intoxicated",
                        "type": 2,
                        "jail": 5,
                        "fine": 375,
                        "description": "Drives while affected by drug or alcohol intoxication. Licenses is suspended ",
                        "points": 0
                    },
                    {
                        "title": "First Degree Speeding",
                        "type": 1,
                        "jail": 0,
                        "fine": 850,
                        "description": "Speeds exceeding the limit by more than 55 mph. Add 3 license points.",
                        "points": 3
                    },
                    {
                        "title": "Second Degree Speeding",
                        "type": 1,
                        "jail": 0,
                        "fine": 500,
                        "description": "Speeds exceeding the limit by 35-55 mph. Add 2 license points.",
                        "points": 2
                    },
                    {
                        "title": "Third Degree Speeding",
                        "type": 1,
                        "jail": 0,
                        "fine": 250,
                        "description": "Speeds exceeding the limit by 0-34 mph. Add 1 license point",
                        "points": 1
                    },
                    {
                        "title": "Improper Window Tint",
                        "type": 2,
                        "jail": 0,
                        "fine": 250,
                        "description": "Operating a vehicle with tint that obscures the view from the outside. Window tint must be completely be dark to where Law Enforcement can't see citizens in the vehicle.  Law Enforcement may use discretion to give a verbal warning, or written violation. Vehicle may be impounded. **Government vehicles are exempt.**",
                        "points": 0
                    },
                    {
                        "title": "Failure to Yield to Emergency Vehicle",
                        "type": 1,
                        "jail": 0,
                        "fine": 200,
                        "description": "Does not pull to the side of the road when an emergency vehicle is trying to pass with sirens and or lights enabled.",
                        "points": 0
                    },
                    {
                        "title": "Failure to Obey a Traffic Control Device",
                        "type": 1,
                        "jail": 0,
                        "fine": 150,
                        "description": "Does not obey a sign or signal defined as regulatory.",
                        "points": 0
                    },
                    {
                        "title": "Negligent Driving",
                        "type": 1,
                        "jail": 0,
                        "fine": 250,
                        "description": "Drives in a way that is negligent with no regard to basic traffic rules.",
                        "points": 2
                    },
                    {
                        "title": "Illegal Passing",
                        "type": 1,
                        "jail": 0,
                        "fine": 250,
                        "description": "Passing another vehicle by a shoulder, median, or solid lines. Passing must be completely made without interfering with safe operation of any approaching vehicle from the opposite direction.",
                        "points": 0
                    },
                    {
                        "title": "Driving on the Wrong Side of The Road",
                        "type": 1,
                        "jail": 0,
                        "fine": 250,
                        "description": "Driving on the left side of the road, against opposing traffic.",
                        "points": 0
                    },
                    {
                        "title": "Illegal Turn",
                        "type": 1,
                        "jail": 0,
                        "fine": 250,
                        "description": "Performing a turn at a stop sign or red light without coming to a full and complete stop, or failure to yield to pedestrians. Making a left-hand turn where signs posted prohibit such a turn.",
                        "points": 0
                    },
                    {
                        "title": "Failure to Stop",
                        "type": 1,
                        "jail": 0,
                        "fine": 250,
                        "description": "Failure to come to a complete and full stop at a posted stop sign or red light. Right on red is permitted when a full stop is completed and after yielding to traffic and pedestrians.",
                        "points": 0
                    },
                    {
                        "title": "Unauthorized Parking",
                        "type": 1,
                        "jail": 0,
                        "fine": 400,
                        "description": "Parks in an area that is unsafe or on government property. Parking on a sidewalk, to include ANY portion of the tire touching the curb. Parking in the wrong direction of traffic. Parking on a red line. Parking in front of a fire hydrant. Parking vehicle across multiple parking spaces. Vehicle is subject to being towed. Government vehicles with lights and/or sirens on are exempt. Further, a vehicle may be driven onto a curb or sidewalk for the purposes of immediately parking that vehicle within a garage or driveway. ",
                        "points": 0
                    },
                    {
                        "title": "Operating a Motor Vehicle Without Proper Identification ",
                        "type": 1,
                        "jail": 0,
                        "fine": 250,
                        "description": "Person has a valid drivers license but is unable to provide a valid citizen identification to law enforcement upon request. Vehicle is to be impounded by law enforcement. This law is to ensure that citizens provide proper identification to law enforcement while operating a motor vehicle.",
                        "points": 0
                    },
                    {
                        "title": "Failure to Signal",
                        "type": 1,
                        "jail": 0,
                        "fine": 100,
                        "description": "Does not use a turn signal when necessary.",
                        "points": 0
                    },
                    {
                        "title": "Driving Without Headlights During Darkness",
                        "type": 1,
                        "jail": 0,
                        "fine": 100,
                        "description": "Driving after dusk and before dawn or in other poor visiblity conditions without headlights.",
                        "points": 0
                    }
                ]
            ]])
        )
    end
end