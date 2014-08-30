root = exports ? this

root.questions = [
  {
    text: 'Which of the following are voluntary movements?'
    title: '1-1-1 Question 1'
    type: 'checkbox'
    options: [
      'Laughing at a joke' #
      'Moving food through the intestinal tract'
      'Crying when you hear bad news' #
      'Breathing' #
      'Pumping blood through the circulatory system'
    ]
    correct: [
      0, 2, 3
    ]
    explanation: 'Voluntary movements are self-generated actions driven by the brain. These can be deliberate movements or emotional reactions.'
    videos: [
      {
        name: '1-1-1'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Which of the following stimuli are sensed but not perceived?'
    title: '1-1-1 Question 2'
    type: 'checkbox'
    options: [
      'Vibration'
      'Skin warming'
      'Skin incision'
      'An increase in blood oxygen concentration' #
      'Lung pressure' #
    ]
    correct: [
      3, 4
    ]
    explanation: 'Our bodies are able to detect things (like carbon dioxide concentration in the blood) that we are not able to perceive. Perceivable stimuli are those we are capable of being aware of.'
    videos: [
      {
        name: '1-1-1'
        degree: 1.0
        part: 1
      }
    ]
  }
  {
    text: 'Which of the following are influenced by homeostatic brain functions?'
    title: '1-1-1 Question 3'
    type: 'checkbox'
    options: [
      'Digestion'
      'Breathing'
      'Sleeping'
      'Eating'
      'Blood pressure'
    ]
    correct: [
      0, 1, 2, 3, 4
      # none checked
    ]
    explanation: 'Homeostasis is the process of maintaining healthy internal conditions, such as body temperature, pH, and blood oxygen levels. All of the functions listed as answer options are influenced by homeostatic brain functions.'
    videos: [
      {
        name: '1-1-1'
        degree: 1.0
        part: 2
      }
    ]
  }
  {
    text: 'How well did you understand this video?'
    title: 'some question'
    type: 'radio'
    autoshowvideo: true
    nocheckanswer: true
    options: [
      'perfectly understand'
      'somewhat understand'
      'do not understand'
    ]
    correct: 0
    explanation: 'some explanation'
    videos: [
      {
        name: '1-1-1'
        degree: 1.0
        part: 3
      }
    ]
  }
  {
    text: 'Which of the following are true of the brainstem?'
    title: '1-1-2 Question 1'
    type: 'checkbox'
    options: [
      'Contained in the skull' #
      'Is involved in homeostasis' #
      'Contains motoneurons that control voluntary muscles of the arms and legs'
      'Contains two parts: the midbrain and the hindbrain' #
      'Is viewed more completely in a mid-sagittal cut than from the side' #
    ]
    correct: [
      0, 1, 3, 4
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-1-2'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Which of the following are true of the forebrain?'
    title: '1-1-2 Question 2'
    type: 'checkbox'
    options: [
      'Contained in the skull' #
      'Smaller than the brainstem'
      'Contains motoneurons that control voluntary muscles'
      'Location of abstract cognitive functions' #
      'Required for sensory perception' #
    ]
    correct: [
      0, 3, 4
    ]
    explanation: 'The forebrain includes the cerebral cortex and is the "seat of consciousness." All perception and abstract cognitive functions like memory are contained in the forebrain.'
    videos: [
      {
        name: '1-1-2'
        degree: 1.0
        part: 1
      }
    ]
  }
  {
    text: 'Which of the following are true about neurons?'
    title: '1-2-1 Question 1'
    type: 'checkbox'
    options: [
      'There are far more different types of neurons than there are types of bone or pancreatic cells' #
      'Neurons can be longer than any other type of cell in the body' #
      'Neurons are the most important cell type in the nervous system' #
      'There are only about 10 different types of neurons'
    ]
    correct: [
      0, 1, 2
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-2-1'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Which of the following are true about neurons?'
    title: '1-2-2 Question 1'
    type: 'checkbox'
    options: [
      'Dendrites receive information' #
      'The cell body is a cellular part unique to neurons'
      'The synapse is a place of communication between neurons' #
      'Axons carry information from synaptic terminals to the dendrites'
      'There is an empty space between neurons at the synapse' #
    ]
    correct: [
      0, 2, 4
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-2-2'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Which of the following could be on the receiving end of a synapse?'
    title: '1-2-2 Question 2'
    type: 'checkbox'
    options: [
      'Neuronal dendrites' #
      'Skeletal muscle' #
      'Salivary gland' #
      'Smooth muscle in the intestines' #
      'Cardiac muscle of the heart' #
    ]
    correct: [
      0, 1, 2, 3, 4
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-2-2'
        degree: 1.0
        part: 1
      }
    ]
  }
  {
    text: 'Neurons can differ in which of the following features?'
    title: '1-2-3 Question 1'
    type: 'checkbox'
    options: [
      'Connectivity' #
      'Excitability' #
      'Neurotransmitters' #
      'Appearance' #
      'Location' #
    ]
    correct: [
      0, 1, 2, 3, 4
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-2-3'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Which of the following are true of glial cells?'
    title: '1-2-4 Question 1'
    type: 'checkbox'
    options: [
      'There are more types of glial cells than there are types of neurons'
      'Glial cells outnumber neurons' #
      'Astrocytes are the most common type of glial cell' #
      'One type of glial cell makes myelin wherever it is found'
      'Glial cells are critical to brain development' #
    ]
    correct: [
      1, 2, 4
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-2-4'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Which of the following are true of myelin?'
    title: '1-2-5 Question 1'
    type: 'checkbox'
    options: [
      'Myelin reduces the time needed for the brain to send messages.' #
      'Information travels faster on the unmyelinated axons than on the myelinated axons.'
      'Myelin helps humans react more quickly to perceived information.' #
      'About 1/100th of a second is needed for an action potential to travel from the toe to the brain along a myelinated axon.' #
    ]
    correct: [
      0, 2, 3
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-2-5'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Which of the following are true?'
    title: '1-2-5 Question 2'
    type: 'checkbox'
    options: [
      'The neural code consists of a temporal pattern of action potentials.' #
      'Demyelination disrupts the patterning of action potentials.' #
      'Demyelination can result in some action potentials failing to make it to the end of an axon.' #
      'Sometimes demyelination speeds up action potential conduction (another name for travel).'
      'In myelinated axons, spikes jump from one inter-myelin space (called a node) to the next one.' #
    ]
    correct: [
      0, 1, 2, 4
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-2-5'
        degree: 1.0
        part: 1
      }
    ]
  }
  {
    text: 'Which of the following are true?'
    title: '1-2-6 Question 1'
    type: 'checkbox'
    options: [
      'Mutliple sclerosis, a central demyelinating disease, is a disorder of Schwann cells.'
      'Peripheral demyelinating diseases usually impair motor abilities' #
      'Demyelination disrupts the neural code' #
      'The symptoms produced by all central demyelinating diseases are the same'
      'Diseases of different types of glial cells have different effects' #
    ]
    correct: [
      1, 2, 4
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-2-6'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Which of the following are true about the meninges?'
    title: '1-3-1 Question 1'
    type: 'checkbox'
    options: [
      'The outermost meningeal layer, the dura, is the toughest' #
      'The brain is contained within a sack of fluid' #
      'The innermost meningeal layer, the pia, is the most delicate' #
      'There are two meningeal membranes'
      'Low impact blows to the head typically do not produce a concussion' #
    ]
    correct: [
      0, 1, 2, 4
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-3-1'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Which of the following are central neurons?'
    title: '1-3-1 Question 2'
    type: 'checkbox'
    options: [
      'Forebrain neurons' #
      'Motoneurons in the brainstem' #
      'Sensory neurons that respond to injury'
      'Autonomic motor neurons'
    ]
    correct: [
      0, 1
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-3-1'
        degree: 1.0
        part: 1
      }
    ]
  }
  {
    text: 'Which of the following are true of viruses and large molecues such as toxins?'
    title: '1-3-2 Question 1'
    type: 'checkbox'
    options: [
      'They can affect peripheral neurons including sensory neurons' #
      'They can kill affected cells' #
      'They never get through the meninges to reach the central neurons'
      'They can cause changes in the skin innervated by sensory neurons' #
      'All of the above'
    ]
    correct: [
      0, 1, 3
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-3-2'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Which of the following are true of brain tumors?'
    title: '1-3-3 Question 1'
    type: 'checkbox'
    options: [
      'Tumors that start outside the brain can spread to the brain'
      'Intracranial tumors are problematic because they increase pressure within the skull'
      'The most common type of brain tumor is a tumor of immortalized neurons'
      'Glial cells are post-mitotic and therefore do not become cancerous'
    ]
    correct: [
      0, 1
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '1-3-3'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Which of the following are true of cell membranes?'
    title: '2-1-1 Question 1'
    type: 'checkbox'
    options: [
      'Membranes are made up of mostly fat' #
      'Ions pass freely through membranes'
      'Cell membranes seperate the inside of cells from the "extracellular spare" that is outside of the cell' #
      'Ion channels are "doors" through which small charged molecules can pass' #
      'Cells are entirely contained within their cell membrane' #
    ]
    correct: [
      0, 2, 3, 4
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '2-1-1'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Cells have a resting membrane potential at which they "sit" under baseline conditions. Which of the following are true at this resting membrane potential?'
    title: '2-1-1 Question 2'
    type: 'checkbox'
    options: [
      'The chemical and electrical forces trying to move potassium ions are perfectly balanced' #
      'Chemical forces "push" potassium ions from the outside of the cell toward the inside of the cell where they are more concentrated'
      'Electrical forces "push" potassium ions from the outside of the cell toward the inside of the cell' #
      'The resting membrane potential is negative with respect to ground (the outside of the cell)' #
      'The ions that are involved in "making" the membrane potential are potassium, hydrogen and calcium ions'
    ]
    correct: [
      0, 2, 3
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '2-1-1'
        degree: 1.0
        part: 1
      }
    ]
  }
  {
    text: 'Which of the following will lead to an increase in current flow?'
    title: '2-1-2 Question 1'
    type: 'checkbox'
    options: [
      'An increase in potential' #
      'A decrease in potential'
      'An increase in resistance'
      'A decrease in resistance' #
      'None of the above; current is constant'
    ]
    correct: [
      0, 3
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '2-1-2'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Which of the following is true of a neuron?'
    title: '2-1-2 Question 2'
    type: 'checkbox'
    options: [
      'A neuron\'s potential is the difference between the potentials inside and outside of the cell membrane' #
      'Neuronal current is carried by ions that can travel across any part of the plasma membrane'
      'Resistance increases as more and more ion channels open'
    ]
    correct: [
      0
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '2-1-2'
        degree: 1.0
        part: 1
      }
    ]
  }
  {
    text: 'Which of the following are true?'
    title: '2-1-3 Question 1'
    type: 'checkbox'
    options: [
      'The membrane potential is steady and does not vary'
      'Action potentials carry information within a neuron' #
      'Membrane potential changes of under 1 millivolt would die out before making it from the toe to the brain' #
      'Action potentials carry information between neurons'
      'Action potentials are critical for carrying signals over long distances' #
    ]
    correct: [
      1, 2, 4
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '2-1-3'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Action potentials are critical for carrying signals over long distances.'
    title: '2-1-3 Question 2'
    type: 'checkbox'
    options: [
      'More concentrated inside the cell than outside'
      'Travel through ion channels in the cell membrane' #
      'More concentrated outside the cell than inside' #
      'Contribute to the resting membrane potential' #
      'Responsible for the large positive change in the membrane potential during an action potential' #
    ]
    correct: [
      1, 2, 3, 4
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '2-1-3'
        degree: 1.0
        part: 1
      }
    ]
  }
  {
    text: 'Which of the following are true of neurotransmitters?'
    title: '2-2-1 Question 1'
    type: 'checkbox'
    options: [
      'They are the chemical messengers that support communication between neurons' #
      'Molecules that serve as neurotransmitters also serve other functions in the body' #
      'Neurotransmitters are important for communication across the synapse' #
      'Neurotransmitters are important but not critical to nervous system function'
    ]
    correct: [
      0, 1, 2
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '2-2-1'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Which of the following are true of Parkinson’s disease?'
    title: '2-2-1 Question 2'
    type: 'checkbox'
    options: [
      'Neurons can no longer make dopamine'
      'Some of the neurons that make dopamine die' #
      'Providing the substrate for dopamine leads to production of dopamine above normal levels'
      'The substrate for dopamine is provided and serves as a therapeutic' #
    ]
    correct: [
      1, 3
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '2-2-1'
        degree: 1.0
        part: 1
      }
    ]
  }
  {
    text: 'Neurons convey a meaningful message by releasing neurotransmitters only when intended. To make this connection, which of the following occurs?'
    title: '2-2-2 Question 1'
    type: 'checkbox'
    options: [
      'Constitutive (always active) neurotransmitter release is suppressed in the synaptic terminal' #
      'When an action potential arrives, the membrane potential of the synaptic terminal becomes more positive' #
      'Fusion of the vesicular and cell membranes is triggered by the arrival of an action potential' #
      'The arrival of the action potential leads to opening of ion channels that allow calcium ions to flood into the cell' #
      'Calcium ions trigger membrane fusion and therefore neurotransmitter is released' #
    ]
    correct: [
      0, 1, 2, 3, 4
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '2-2-2'
        degree: 1.0
        part: 1
      }
    ]
  }
  {
    text: 'Which of the following are true of Clostridial toxins?'
    title: '2-2-3 Question 1'
    type: 'checkbox'
    options: [
      'Clostridial toxins block neurotransmitter synthesis'
      'Clostridial toxins prevent neurotransmitter release' #
      'Clostridial toxins prevent synaptic vesicle fusion to the cell membrane' #
      'Clostridial toxins include Botulinum toxin' #
      'Clostridial toxins such as Botox cut the Snare pin proteins' #
    ]
    correct: [
      1, 2, 3, 4
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '2-2-3'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Clostridial toxins such as Botox cut the Snare pin proteins'
    title: '2-2-3 Question 2'
    type: 'checkbox'
    options: [
      'Botox can be lethal' #
      'Botox is used cosmetically' #
      'Botox is used therapeutically for a variety of disorders including focal dystonia' #
      'Botox\'s effects stem from its blocking neurotransmitter release from motoneurons' #
      'None of the above'
    ]
    correct: [
      0, 1, 2, 3
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '2-2-3'
        degree: 1.0
        part: 1
      }
    ]
  }
  {
    text: 'When an action potential arrives in a synaptic terminal, neurotransmitter:'
    title: '2-2-4 Question 1'
    type: 'checkbox'
    options: [
      'Is released into the synaptic cleft' #
      'Diffuses out of the synaptic cleft' #
      'Diffuses across the synaptic cleft to the post-synaptic terminal' #
      'Is taken up into the pre-synaptic terminal' #
      'Is taken up into the post-synaptic terminal'
    ]
    correct: [
      0, 1, 2, 3
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '2-2-4'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'In the case of acetylcholine, which is the neurotransmitter of motoneurons:'
    title: '2-2-4 Question 2'
    type: 'checkbox'
    options: [
      'Degradation is accomplished by acetylcholinesterase (AChE)' #
      'Degradation is critical to terminating the motoneuron’s message to muscle' #
      'Enzymatic degradation is the only mechanism by which acetylcholine signaling is terminated'
      'Blocking acetylcholinesterase (AChE) can be therapeutic as in the case of myasthenia gravis' #
      'Blocking acetylcholinesterase (AChE) can be lethal by preventing contraction of the breathing muscle, the diaphragm'
    ]
    correct: [
      0, 1, 3
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '2-2-4'
        degree: 1.0
        part: 1
      }
    ]
  }
  {
    text: 'Which of the following are true of receptors?'
    title: '2-2-5 Question 1'
    type: 'checkbox'
    options: [
      'They are single proteins that span the cell membrane'
      'Opening a receptor through which chloride ions (Cl-) enter the cell will have an excitatory effect'
      'When neurotransmitter binds, they open a pore through which ions can travel' #
      'Opening a receptor that makes the membrane potential more positive will have an inhibitory effect'
      'They are located on the postsynaptic membrane' #
    ]
    correct: [
      2, 4
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '2-2-5'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    text: 'Regarding myasthenia gravis, which of the following is true?'
    title: '2-2-5 Question 2'
    type: 'checkbox'
    options: [
      'The patient’s own immune system destroys acetylcholine receptors or leads to their dispersal in the muscle membrane' #
      'The muscle does not contract or contracts weakly' #
      'Acetylcholine is released normally from the motoneuron' #
      'Treatment aimed at relieving symptoms is geared toward increasing acetylcholine in the synaptic cleft by blocking acetylcholinesterase' #
      'Treatment aimed at the underlying cause is geared toward boosting the immune system'
    ]
    correct: [
      0, 1, 2, 3
    ]
    explanation: '(see correct answers above)'
    videos: [
      {
        name: '2-2-5'
        degree: 1.0
        part: 1
      }
    ]
  }
]
