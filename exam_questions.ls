root = exports ? this

root.exam_questions = [
  {
    course: 1
    half: 1
    text: 'Damage to the spinal cord could cause impairment of which of the following functions?'
    title: 'Question 1'
    type: 'checkbox'
    options: [
      'Voluntary movement of the arms and legs' #
      'Speech'
      'Perception' #
      'Homeostasis' #
      'Abstract functions'
    ]
    correct: [
      0, 2, 3
    ]
    explanation: ''
    videos: [
      {
        name: '1-2-2'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    course: 1
    half: 1
    text: 'Damage to the brainstem could cause impairment of which of the following functions?'
    title: 'Question 2'
    type: 'checkbox'
    options: [
      'Voluntary movement of the arms and legs' #
      'Speech' #
      'Perception' #
      'Homeostasis' #
      'Abstract functions'
    ]
    correct: [
      0, 1, 2, 3
    ]
    explanation: 'The brain stem is involved in all of the functions except for abstract functions.'
    videos: [
      {
        name: '1-2-2'
        degree: 1.0
        part: 1
      }
    ]
  }
  {
    course: 1
    half: 1
    text: 'Damage to the forebrain could cause impairment of which of the following functions?'
    title: 'Question 3'
    type: 'checkbox'
    options: [
      'Voluntary movement of the arms and legs' #
      'Speech' #
      'Perception' #
      'Homeostasis' #
      'Abstract function' #
    ]
    correct: [
      0, 1, 2, 3, 4
      # none checked
    ]
    explanation: 'The forebrain is involved in all of the listed functions'
    videos: [
      {
        name: '1-2-2'
        degree: 1.0
        part: 2
      }
    ]
  }
  {
    course: 1
    half: 1
    text: 'A mutation that led to the degeneration of glial cells could result in which of the following?'
    title: 'Question 4'
    type: 'checkbox'
    options: [
      'Neuronal death' #
      'Central-only demyelination' #
      'Peripheral-only demyelination' #
      'Abnormal development' #
      'None of the above'
    ]
    correct: [
      0, 1, 2, 3
    ]
    explanation: ''
    videos: [
      {
        name: '1-3-4'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    course: 1
    half: 2
    text: 'Which of the following are inside (underneath) the arachnoid layer?'
    title: 'Question 5'
    type: 'checkbox'
    options: [
      'Dura'
      'Pia' #
      'Motoneuronal cell bodies' #
      'Autonomic ganglion neurons'
      'Neurons of the spinal cord' #
    ]
    correct: [
      1, 2, 4
    ]
    explanation: ''
    videos: [
      {
        name: '1-4-1'
        degree: 1.0
        part: 1
      }
    ]
  }
  {
    course: 1
    half: 1
    text: 'Within a neuron, information flows in which direction(s)?'
    title: 'Question 6'
    type: 'checkbox'
    options: [
      'Dendrites to cell body' #
      'Cell body to axons' #
      'Axon to dendrites'
      'Axon to cell body'
      'Axon to synaptic terminal' #
    ]
    correct: [
      0, 1, 4
    ]
    explanation: 'Information comes in through the dendrites, to the cell bodies, down the axon to the synaptic terminal.'
    videos: [
      {
        name: '1-3-2'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    course: 1
    half: 1
    text: 'Between neurons, information flows in which directions?'
    title: 'Question 7'
    type: 'checkbox'
    options: [
      'Synaptic terminal to axon'
      'Axon to synaptic terminal'
      'Dendrite to synaptic terminal'
      'Synaptic terminal to dendrite' #
      'Cell body to dendrite'
      'None of the above'
    ]
    correct: [
      3
    ]
    explanation: ''
    videos: [
      {
        name: '1-3-2'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    course: 1
    half: 2
    text: 'There are no more than 100,000 motoneurons and yet these are the only neurons that:'
    title: 'Question 8'
    type: 'checkbox'
    options: [
      'Send a process out that leaves the central nervous system'
      'Innervate voluntary muscles such as the quadriceps or biceps' #
      'Allow us to express ourselves volitionally' #
      'Travel through the spinal cord'
      'Have dendrites'
      'None of the above'
    ]
    correct: [
      1, 2
    ]
    explanation: ''
    videos: [
      {
        name: '1-3-6'
        degree: 1.0
        part: 1
      }
    ]
  }
  {
    course: 1
    half: 2
    text: 'Which of the following are true of myelin?'
    title: 'Question 9'
    type: 'checkbox'
    options: [
      'It covers all axons in the central nervous system'
      'It covers some of the axons in the peripheral nervous system' #
      'It changes the speed at which action potentials travel down an axon, increasing the speed in some axons and decreasing it in others'
      'Losing myelin will increase the conduction velocity of action potentials'
      'None of the above'
    ]
    correct: [
      1
    ]
    explanation: 'Myelin is wrapped around the axon of some neurons and increases the speed of action potential conduction.'
    videos: [
      {
        name: '1-3-5'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    course: 1
    half: 2
    text: 'An intracranial tumor is least likely to be made up of which type of cells?'
    title: 'Question 10'
    type: 'checkbox'
    options: [
      'Lung'
      'Arachnoid'
      'Pituitary cells'
      'Astrocytes'
      'Glial cells are critical to brain development' #
    ]
    correct: [
      4
    ]
    explanation: 'Neurons are rarely the source of tumors because they are no longer able to divide.'
    videos: [
      {
        name: '1-4-3'
        degree: 1.0
        part: 0
      }
    ]
  }
  {
    course: 1
    half: 2
    text: 'You discover a new toxin which, like most toxins, is a large molecule that can reach peripheral neurons but cannot cross the meninges on its own. Which of the following symptoms may result from exposure to this toxin?'
    title: 'Question 11'
    type: 'checkbox'
    options: [
      'Amnesia'
      'Depression'
      'Paralysis of voluntary muscles' #
      'Dry mouth due to lack of salivation' #
      'Constipation due to gut immobility' #
    ]
    correct: [
      2, 3, 4
    ]
    explanation: 'The toxin can only access neuronal cell bodies or synaptic terminals that are present peripherally. With an exception, the central nervous system will not be affected by the toxin. The exception is that motoneurons (that innervate skeletal muscle for volitional movement) and autonomic motor neurons (that innervate autonomic ganglia neurons which in turn innervate glands, cardiac or smooth muscle) may take up a toxin in the periphery and transport it back to the cell body that is located centrally. This happens with polio.'
    videos: [
      {
        name: '1-4-2'
        degree: 1.0
        part: 0
      }
    ]
  }
]
